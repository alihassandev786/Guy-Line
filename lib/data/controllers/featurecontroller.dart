import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
import '../services/chatservice.dart';
import '../services/sessionmanager.dart';
import 'conservationcontroller.dart';

/// -----------------------------------------------------------------------
/// SHARED CONTROLLER for Help Me Say It / Help Me Decide / Make a Plan
/// -----------------------------------------------------------------------
class FeatureController extends GetxController {
  final ChatService _chatService = ChatService();

  ConversationController get _conversationController =>
      Get.isRegistered<ConversationController>()
          ? Get.find<ConversationController>()
          : Get.put(ConversationController());

  int? get _userId => SessionManager.instance.getUser()?.id;
  int? get _conversationId => _conversationController.conversationId.value;

  // ======================================================================
  // HELPER — auto create conversation if none exists
  // ======================================================================
  Future<bool> _ensureConversationExists(String seedMessage) async {
    if (_conversationId != null) return true;

    final userId = _userId;
    if (userId == null) {
      _showError("User session not found. Please login again.");
      return false;
    }

    final conv = _conversationController;
    final time = _formatTime(DateTime.now());

    // Optimistic UI
    conv.messages.add(ChatMessage(
      text: seedMessage,
      time: time,
      isSender: true,
    ));

    final result = await _chatService.sendMessage(
      userId: userId,
      message: seedMessage,
      category: conv.category.value,
      conversationId: null,
    );

    if (result.success && result.conversationId != null) {
      conv.conversationId.value = result.conversationId;

      if (result.reply != null && result.reply!.isNotEmpty) {
        conv.messages.add(ChatMessage(
          text: result.reply!,
          time: _formatTime(DateTime.now()),
          isSender: false,
        ));
      }
      return true;
    } else {
      if (conv.messages.isNotEmpty && conv.messages.last.isSender) {
        conv.messages.removeLast();
      }
      _showError(result.message.isNotEmpty
          ? result.message
          : "Could not start conversation. Please try again.");
      return false;
    }
  }

  String _formatTime(DateTime now) {
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  // ======================================================================
  // HELP ME SAY IT
  // ======================================================================
  final RxString sayItTitle = "Help Me Say It".obs;
  final RxString sayItSubtitle = "Drafting response...".obs;
  final RxString generatedText = "".obs;
  final RxString sayItRecipientName = "the recipient".obs;
  final RxString sayItTone = "formal".obs;
  final isGeneratingSayIt = false.obs;

  final TextEditingController sayItInputController = TextEditingController();

  final List<String> sayItChips = const [
    "Make Formal",
    "Make It Shorter",
    "Softer Tone",
  ];

  Future<void> loadSayItDraft({String? recipientName, String? tone}) async {
    final userId = _userId;

    if (userId == null) {
      _showError("User session not found. Please login again.");
      return;
    }

    final hasConversation = await _ensureConversationExists(
      "I need help saying something. Can you draft a message for me?",
    );
    if (!hasConversation) return;

    final conversationId = _conversationId;
    if (conversationId == null) {
      _showError("Could not start conversation. Please try again.");
      return;
    }

    if (recipientName != null) sayItRecipientName.value = recipientName;
    if (tone != null) sayItTone.value = tone;

    sayItSubtitle.value = "Drafting response to ${sayItRecipientName.value}";
    isGeneratingSayIt.value = true;
    generatedText.value = "";

    print("🟡 [FeatureController] Requesting Help Me Say It draft (tone: ${sayItTone.value})");

    final result = await _chatService.helpMeSayIt(
      userId: userId,
      conversationId: conversationId,
      recipientName: sayItRecipientName.value,
      tone: sayItTone.value,
    );

    isGeneratingSayIt.value = false;

    if (result.success && result.draft != null && result.draft!.isNotEmpty) {
      generatedText.value = result.draft!;
      print("✅ [FeatureController] Draft received");
    } else {
      generatedText.value =
          result.draft ?? "Sorry, I couldn't process that right now. Please try again.";
      print("❌ [FeatureController] Draft failed: ${result.message}");
    }
  }

  Future<void> onSayItChipTap(String chip) async {
    if (isGeneratingSayIt.value) return;

    // Backend valid tones: formal, shorter, soft → "soft" invalid hai logs mein
    // "Softer Tone" ko "casual" ya "soft" se map karte hain. Logs mein "soft" fail hua.
    // Safe mapping:
    String tone;
    switch (chip) {
      case "Make Formal":
        tone = "formal";
        break;
      case "Make It Shorter":
        tone = "shorter";
        break;
      case "Softer Tone":
        tone = "casual"; // backend "soft" ko reject kar raha tha
        break;
      default:
        tone = "formal";
    }

    await loadSayItDraft(tone: tone);
  }

  void copyGeneratedText() {
    Clipboard.setData(ClipboardData(text: generatedText.value));
   SnackbarService.success("Text copied to clipboard");
  }

  Future<void> sendGeneratedTextToChat() async {
    if (generatedText.value.isEmpty) return;
    await _sendToConversation(generatedText.value);
  }

  Future<void> sendSayItCustomText() async {
    final text = sayItInputController.text.trim();
    if (text.isEmpty) return;
    sayItInputController.clear();
    await _sendToConversation(text);
  }

  // ======================================================================
  // HELP ME DECIDE
  // ======================================================================
  final RxString decideSummary = "".obs;
  final RxList<DecideOption> decideOptions = <DecideOption>[].obs;
  final isLoadingDecide = false.obs;

  final TextEditingController decideInputController = TextEditingController();

  Future<void> loadDecideAnalysis() async {
    final userId = _userId;

    if (userId == null) {
      _showError("User session not found. Please login again.");
      return;
    }

    isLoadingDecide.value = true;
    decideOptions.clear();
    decideSummary.value = "Analyzing...";

    final hasConversation = await _ensureConversationExists(
      "I need help deciding something. Can you analyze the options for me?",
    );

    if (!hasConversation) {
      isLoadingDecide.value = false;
      decideSummary.value = "Could not start conversation. Please try again.";
      return;
    }

    final conversationId = _conversationId;
    if (conversationId == null) {
      isLoadingDecide.value = false;
      decideSummary.value = "Could not start conversation. Please try again.";
      return;
    }

    decideSummary.value = "Analyzing your conversation...";

    print("🟡 [FeatureController] Requesting Help Me Decide analysis");

    final result = await _chatService.helpMeDecide(
      userId: userId,
      conversationId: conversationId,
    );

    isLoadingDecide.value = false;

    if (result.success) {
      decideSummary.value = result.summary.isNotEmpty
          ? result.summary
          : "Here are some options based on your conversation.";

      decideOptions.assignAll(result.options.map((o) => DecideOption(
        title: o.title,
        subtitle: o.subtitle,
        pros: o.pros,
        cons: o.cons,
      )));

      print("✅ [FeatureController] Decision analysis received (${decideOptions.length} options)");
    } else {
      decideSummary.value =
      "Sorry, I couldn't process that right now. Please try again.";
      print("❌ [FeatureController] Decision analysis failed: ${result.message}");
    }
  }

  Future<void> selectDecideOption(DecideOption option) async {
    final msg =
        "I choose ${option.title}.\n\nPros:\n• ${option.pros.join('\n• ')}\n\nCons:\n• ${option.cons.join('\n• ')}";
    await _sendToConversation(msg);
  }

  Future<void> sendDecideCustomText() async {
    final text = decideInputController.text.trim();
    if (text.isEmpty) return;
    decideInputController.clear();
    await _sendToConversation(text);
  }

  // ======================================================================
  // MAKE A PLAN
  // ======================================================================
  final RxString planIntro = "".obs;
  final RxList<PlanItem> planItems = <PlanItem>[].obs;
  final isLoadingPlan = false.obs;

  final TextEditingController planInputController = TextEditingController();

  int get selectedPlanCount =>
      planItems.where((e) => e.isSelected.value).length;

  Future<void> loadPlanSuggestions() async {
    final userId = _userId;

    if (userId == null) {
      _showError("User session not found. Please login again.");
      return;
    }

    isLoadingPlan.value = true;
    planItems.clear();
    planIntro.value = "Generating your plan...";

    final hasConversation = await _ensureConversationExists(
      "I need help making a plan. Can you suggest some next steps?",
    );

    if (!hasConversation) {
      isLoadingPlan.value = false;
      planIntro.value = "Could not start conversation. Please try again.";
      return;
    }

    final conversationId = _conversationId;
    if (conversationId == null) {
      isLoadingPlan.value = false;
      planIntro.value = "Could not start conversation. Please try again.";
      return;
    }

    print("🟡 [FeatureController] Requesting Make a Plan suggestions");

    final result = await _chatService.makeAPlan(
      userId: userId,
      conversationId: conversationId,
    );

    isLoadingPlan.value = false;

    if (result.success && result.steps.isNotEmpty) {
      planIntro.value =
      "Based on our conversation, here are some suggested next steps.";
      planItems.assignAll(result.steps.map((s) => PlanItem(
        title: s.title,
        description: s.description,
      )));
      print("✅ [FeatureController] Plan received (${planItems.length} items)");
    } else {
      planIntro.value =
      "Sorry, I couldn't process that right now. Please try again.";
      print("❌ [FeatureController] Plan generation failed: ${result.message}");
    }
  }

  void togglePlanItem(int index) {
    if (index < 0 || index >= planItems.length) return;
    planItems[index].isSelected.toggle();
  }

  Future<void> addSelectedToPlan() async {
    final selected = planItems.where((e) => e.isSelected.value).toList();
    if (selected.isEmpty) {
      SnackbarService.error("Please select at least one suggestion");
      return;
    }
    final msg = selected.map((e) => "• ${e.title}").join("\n");
    await _sendToConversation(msg);
  }

  Future<void> sendPlanCustomText() async {
    final text = planInputController.text.trim();
    if (text.isEmpty) return;
    planInputController.clear();
    await _sendToConversation(text);
  }

  // ======================================================================
  // SHARED HELPERS
  // ======================================================================
  Future<void> _sendToConversation(String message) async {
    final conv = _conversationController;

    // Close bottom sheet if open (Help Me Say It)
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }

    // Feature screens (Help Me Decide / Make a Plan) ko stack se hata do
    // aur Conservation pe replace kar do — taake Conversation se back → Home
    if (Get.currentRoute != AppRoutes.conservation) {
      Get.offNamed(AppRoutes.conservation);   // ← push nahi, offNamed
    }

    await conv.sendText(message);
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SnackbarService.error(message);
    });
  }

  @override
  void onClose() {
    sayItInputController.dispose();
    decideInputController.dispose();
    planInputController.dispose();
    super.onClose();
  }
}

/// Models used by UI
class DecideOption {
  final String title;
  final String subtitle;
  final List<String> pros;
  final List<String> cons;

  DecideOption({
    required this.title,
    required this.subtitle,
    required this.pros,
    required this.cons,
  });
}

class PlanItem {
  final String title;
  final String description;
  final RxBool isSelected;

  PlanItem({
    required this.title,
    required this.description,
    bool selected = false,
  }) : isSelected = selected.obs;
}