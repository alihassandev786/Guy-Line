import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
import 'package:guyline/presentation/bottomnavigationsection/homesection/helpmedecide.dart';
import 'package:guyline/presentation/bottomnavigationsection/homesection/makeaplan.dart';

import '../../presentation/bottomnavigationsection/homesection/helpmesayitbottomsheet.dart';
import '../services/chatservice.dart';
import '../services/historyservice.dart';
import '../services/sessionmanager.dart';
import 'historycontroller.dart';

/// -----------------------------------------------------------------------
/// MODEL — single chat message (for UI display)
/// -----------------------------------------------------------------------
class ChatMessage {
  final String text;
  final String time;
  final bool isSender; // true = sent by current user (right side)

  ChatMessage({
    required this.text,
    required this.time,
    required this.isSender,
  });
}

/// -----------------------------------------------------------------------
/// SHARED CONTROLLER — used by BOTH Conversation.dart and Chatbot.dart
/// -----------------------------------------------------------------------
class ConversationController extends GetxController {
  final ChatService _chatService = ChatService();

  /// ---------------- Shared conversation state ----------------
  final RxString chatTitle = "New Conversation".obs;
  final RxString chatDate = "".obs;

  /// Null until the first message is sent (Chatbot) or an existing
  /// conversation is opened from Home's recent list.
  final Rxn<int> conversationId = Rxn<int>();

  /// Category picked on Homescreen before starting a chat (e.g. "Work").
  final RxString category = "General".obs;

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final TextEditingController messageInputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  /// Loading states
  final isSendingMessage = false.obs;
  final isAiTyping = false.obs; // three-dots while waiting for AI
  final isLoadingConversation = false.obs;

  int? get _userId => SessionManager.instance.getUser()?.id;

  // -------------------- Start / Reset --------------------
  /// Call before navigating into a brand-new chat (Home category tap,
  /// "Start Talking") so old messages/category don't linger.
  void startNewConversation({String? withCategory}) {
    conversationId.value = null;
    messages.clear();
    chatDate.value = "Today, ${_currentTime()}";
    category.value = withCategory ?? "General";

    // Sirf category select hone pe title set karo
    // Start Talking pe title empty rahega → top pe topic nahi dikhega
    if (withCategory != null && withCategory.isNotEmpty) {
      chatTitle.value = withCategory;
    } else {
      chatTitle.value = "";
    }

    print("🟣 [ConversationController] Started new conversation — category: ${category.value}, title: '${chatTitle.value}'");
  }

  /// Called from Homescreen when a category card is tapped.
  void setCategory(String newCategory) {
    category.value = newCategory;
  }

  // -------------------- Load Existing Conversation (GET) --------------------
  Future<void> loadConversation(int id) async {
    final userId = _userId;
    if (userId == null) {
      SnackbarService.error("User session not found. Please login again.");
      return;
    }

    isLoadingConversation.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    print("🟡 [ConversationController] Loading conversation #$id");

    final result = await _chatService.getConversation(
      conversationId: id,
      userId: userId,
    );

    isLoadingConversation.value = false;
    Get.back(); // close loading dialog

    if (result.success) {
      conversationId.value = result.conversation?.id ?? id;
      chatTitle.value = result.conversation?.title ?? chatTitle.value;
      category.value = result.conversation?.category ?? category.value;
      chatDate.value = result.conversation?.createdAt ?? chatDate.value;

      messages.assignAll(
        result.messages
            .map((m) => ChatMessage(
          text: m.message,
          time: m.time,
          isSender: m.sender == "user",
        ))
            .toList(),
      );

      print("✅ [ConversationController] Conversation #$id loaded — ${messages.length} messages");
      AppNavigator.pushRight(AppRoutes.conservation);
      _scrollToBottom();
      // History ko turant update karo taake naya chat History tab mein dikhe
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().refresh();
      }
    } else {
      print("❌ [ConversationController] Failed to load conversation: ${result.message}");
     SnackbarService.error(result.message);
    }
  }

  // -------------------- Send Message (Conservation screen) --------------------
  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty || isSendingMessage.value) return;
    messageInputController.clear();
    _sendToApi(text);
  }
  /// Public wrapper so other controllers (Help Me Say It / Help Me Decide /
  /// Make a Plan via FeatureController) can push text into THIS SAME
  /// conversation through the real backend, instead of just appending
  /// locally. Keeps Chatbot & Conservation as the single source of truth.
  Future<void> sendText(String text) => _sendToApi(text);

  void onEmojiTap() {
    // TODO: hook up an emoji picker.
  }

  /// ---------------- Chatbot (AI assistant) state ----------------
  final RxString userName = "Alex".obs;
  final TextEditingController assistantInputController = TextEditingController();

  /// Always the FIRST message of a (possibly brand-new) conversation.
  void sendFromChatbot() {
    final text = assistantInputController.text.trim();
    if (text.isEmpty || isSendingMessage.value) return;
    assistantInputController.clear();

    // Navigate right away so the user's message appears to land instantly;
    // the actual API call keeps running against the same shared controller.
    // Chatbot ko stack se hata do, Conservation replace ho
    Get.offNamed(AppRoutes.conservation);
    _sendToApi(text);
  }

  void onMicTap() {
    // TODO: hook up voice input.
  }

  /// Shared send logic for Chatbot's first message AND Conservation's
  /// follow-up messages.
  Future<void> _sendToApi(String text) async {
    final userId = _userId;
    if (userId == null) {
      SnackbarService.error("User session not found. Please login again.");

      return;
    }

    // Optimistically show the user's own message immediately.
    messages.add(ChatMessage(text: text, time: _currentTime(), isSender: true));

    // Title ko pehle message se set NAHI karte.
    // Title sirf tab dikhega jab category select ki ho (Home se).
    // Start Talking case mein chatTitle empty rehta hai.

    _scrollToBottom();

    isSendingMessage.value = true;
    isAiTyping.value = true; // show "..." typing bubble
    print("🟡 [ConversationController] Sending message: \"$text\" (category: ${category.value})");

    final result = await _chatService.sendMessage(
      userId: userId,
      message: text,
      category: category.value,
      conversationId: conversationId.value,
    );

    isSendingMessage.value = false;
    isAiTyping.value = false; // hide typing bubble

    if (result.success) {
      conversationId.value = result.conversationId ?? conversationId.value;

      messages.add(
        ChatMessage(
          text: (result.reply != null && result.reply!.isNotEmpty)
              ? result.reply!
              : "Sorry, I couldn't process that right now. Please try again.",
          time: _currentTime(),
          isSender: false,
        ),
      );

      print("✅ [ConversationController] Reply received — conversation #${conversationId.value}");
      _scrollToBottom();

      // History list turant update
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().refresh();
      }
    } else {
      print("❌ [ConversationController] Send failed: ${result.message}");
      SnackbarService.error(result.message);

    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Multiple ListView attach hone pe crash na ho
      if (!chatScrollController.hasClients) return;
      if (chatScrollController.positions.length != 1) return;

      try {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } catch (_) {
        // ignore if controller not ready
      }
    });
  }
  /// ---------------- Suggestion chips (shared) ----------------
  final List<String> suggestionChips = const [
    "Help Me Say It",
    "Help Me Decide",
    "Make a Plan",
  ];

  void onSuggestionTap(String chipText) {
    if (chipText == "Help Me Say It") {
      HelpMeSayItBottomSheet.show();
    } else if (chipText == "Help Me Decide") {
      Get.to(() => const Helpmedecide());
    } else if (chipText == "Make a Plan") {
      Get.to(() => const Makeaplan());
    } else {
      assistantInputController.text = chipText;
      messageInputController.text = chipText;
    }
  }

  /// ---------------- Shared ----------------
  /// Always return to Bottom Navigation (Home), never leave user stuck in deep stack.
  void goBack() {
    // Pop until we reach bottom navigation, or clear stack if needed
    if (Get.currentRoute == AppRoutes.bottomnavigation) return;

    Get.until((route) {
      return route.settings.name == AppRoutes.bottomnavigation || route.isFirst;
    });

    // Safety: if somehow still not on bottom nav
    if (Get.currentRoute != AppRoutes.bottomnavigation) {
      Get.offAllNamed(AppRoutes.bottomnavigation);
    }
  }
  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }
  /// History se purani conversation load karne ke liye.
  /// Top pe topic = CATEGORY (jab real category ho), pehla-message title nahi.
  Future<void> loadExistingConversation(
      int id, {
        String? title,
        String? category,
      }) async {
    conversationId.value = id;
    messages.clear();

    // Category set karo pehle
    if (category != null && category.isNotEmpty) {
      this.category.value = category;
    } else {
      this.category.value = "General";
    }

    // Topic (chatTitle) = category jab woh real topic ho (General nahi)
    // Start Talking / General → top pe kuch nahi
    final cat = this.category.value.trim();
    if (cat.isNotEmpty && cat.toLowerCase() != "general") {
      chatTitle.value = cat;
    } else {
      chatTitle.value = "";
    }

    final result = await HistoryService().getConversationDetail(id);

    if (result.success && result.data != null) {
      final data = result.data!;

      // Meta se category / date update — title ko first-message se overwrite MAT karo
      final convMeta = data["conversation"];
      if (convMeta is Map) {
        final c = convMeta["category"]?.toString();
        if (c != null && c.isNotEmpty) {
          this.category.value = c;
          // Category real topic hai to top pe category hi dikhao
          if (c.toLowerCase() != "general") {
            chatTitle.value = c;
          } else {
            chatTitle.value = "";
          }
        }
        final created = convMeta["created_at"]?.toString();
        if (created != null && created.isNotEmpty) {
          chatDate.value = created;
        }
      }

      List<dynamic> rawMessages = [];

      if (data["messages"] is List) {
        rawMessages = data["messages"];
      } else if (data["conversation"] != null &&
          data["conversation"]["messages"] is List) {
        rawMessages = data["conversation"]["messages"];
      } else if (data["data"] is List) {
        rawMessages = data["data"];
      }

      for (var msg in rawMessages) {
        final text = msg["message"] ?? msg["content"] ?? msg["text"] ?? "";
        final isUser = msg["role"] == "user" ||
            msg["is_user"] == true ||
            msg["sender"] == "user";

        messages.add(ChatMessage(
          text: text.toString(),
          time: msg["created_at"]?.toString() ??
              msg["time"]?.toString() ??
              "",
          isSender: isUser,
        ));
      }

      print("✅ Loaded ${messages.length} messages for conversation #$id — topic: ${chatTitle.value}, category: ${this.category.value}");
    } else {
      print("❌ Failed to load conversation detail");
    }
  }
  @override
  void onClose() {
    messageInputController.dispose();
    assistantInputController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}