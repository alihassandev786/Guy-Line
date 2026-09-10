import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// -----------------------------------------------------------------------
/// MODEL — single chat message
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
  /// ---------------- Conversation (human chat) state ----------------
  final RxString chatTitle = "Work".obs;
  final RxString chatDate = "Today, 10:42 AM".obs;

  final RxList<ChatMessage> messages = <ChatMessage>[
    ChatMessage(
      text: "Thanks for joining the stream.",
      time: "09:00 AM",
      isSender: false,
    ),
    ChatMessage(
      text: "It was really too amazing…",
      time: "09:05 AM",
      isSender: true,
    ),
    ChatMessage(
      text: "Glad to hear that you enjoyed it.",
      time: "09:10 AM",
      isSender: false,
    ),
    ChatMessage(
      text:
      "It was really too amazing... I really enjoyed it and want to join next session aslo..",
      time: "09:15 AM",
      isSender: true,
    ),
    ChatMessage(
      text: "Ohh! Thats really Great 😀",
      time: "09:20 AM",
      isSender: false,
    ),
  ].obs;

  final TextEditingController messageInputController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    messages.add(
      ChatMessage(
        text: text,
        time: _currentTime(),
        isSender: true,
      ),
    );
    messageInputController.clear();

    // Scroll to bottom after the frame renders the new bubble.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onEmojiTap() {
    // TODO: hook up an emoji picker.
  }

  /// ---------------- Chatbot (AI assistant) state ----------------
  final RxString userName = "Alex".obs;
  final TextEditingController assistantInputController =
  TextEditingController();

  void askAssistant() {
    final text = assistantInputController.text.trim();
    if (text.isEmpty) return;

    // TODO: send `text` to your AI backend and route to the response UI.
    assistantInputController.clear();
  }

  void onMicTap() {
    // TODO: hook up voice input.
  }

  /// ---------------- Shared ----------------
  void goBack() => Get.back();

  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  void onClose() {
    messageInputController.dispose();
    assistantInputController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }
}