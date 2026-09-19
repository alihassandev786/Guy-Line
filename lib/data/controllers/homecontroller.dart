import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/data/services/historyservice.dart';
import 'conservationcontroller.dart';
class CategoryItem {
  final String title;
  final IconData icon;
  final Color iconColor;

  CategoryItem({
    required this.title,
    required this.icon,
    required this.iconColor,
  });
}

class RecentItem {
  final int conversationId;
  final String title;
  final String subtitle;
  final String? category;

  RecentItem({
    required this.conversationId,
    required this.title,
    required this.subtitle,
    this.category,
  });
}

class HomeController extends GetxController {
  final HistoryService _historyService = HistoryService();

  ConversationController get _conversationController =>
      Get.isRegistered<ConversationController>()
          ? Get.find<ConversationController>()
          : Get.put(ConversationController());

  final RxList<CategoryItem> categories = <CategoryItem>[
    CategoryItem(
      title: "Relationship",
      icon: Icons.favorite_border_rounded,
      iconColor: const Color(0xFFFF7A00),
    ),
    CategoryItem(
      title: "Money",
      icon: Icons.account_balance_wallet_outlined,
      iconColor: const Color(0xFF2F80ED),
    ),
    CategoryItem(
      title: "Work",
      icon: Icons.business_center_outlined,
      iconColor: const Color(0xFF00C9A7),
    ),
    CategoryItem(
      title: "Dad Stuff",
      icon: Icons.family_restroom_rounded,
      iconColor: const Color(0xFFFF9F43),
    ),
    CategoryItem(
      title: "Decisions",
      icon: Icons.alt_route_rounded,
      iconColor: const Color(0xFF54a0ff),
    ),
    CategoryItem(
      title: "I’m Pissed",
      icon: Icons.local_fire_department_outlined,
      iconColor: const Color(0xFFFF5252),
    ),
    CategoryItem(
      title: "Goals",
      icon: Icons.flag_outlined,
      iconColor: const Color(0xFFFFB300),
    ),
    CategoryItem(
      title: "Just Talk",
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: const Color(0xFFFFD54F),
    ),
  ].obs;

  /// Real recent chats from History API (not hardcoded)
  final RxList<RecentItem> recentItems = <RecentItem>[].obs;
  final isLoadingRecent = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentConversations();
  }

  @override
  void onReady() {
    super.onReady();
    loadRecentConversations();
  }

  /// Load last few conversations from /api/history
  Future<void> loadRecentConversations() async {
    isLoadingRecent.value = true;
    try {
      final result = await _historyService.getHistory();
      if (result.success && result.conversations.isNotEmpty) {
        // Take latest 5
        final items = result.conversations.take(5).map((c) {
          final cat = c.category ?? "";
          final time = c.timeAgo ?? "";
          final subtitle = [
            if (cat.isNotEmpty) cat,
            if (time.isNotEmpty) time,
          ].join(" · ");

          return RecentItem(
            conversationId: c.id,
            title: (c.title != null && c.title!.isNotEmpty)
                ? c.title!
                : (cat.isNotEmpty ? cat : "Conversation"),
            subtitle: subtitle.isNotEmpty ? subtitle : "Recent chat",
            category: c.category,
          );
        }).toList();
        recentItems.assignAll(items);
      } else {
        recentItems.clear();
      }
    } catch (e) {
      print("❌ [HomeController] Failed to load recent: $e");
      recentItems.clear();
    } finally {
      isLoadingRecent.value = false;
    }
  }

  /// "Start Talking" — chatbot, no category topic
  void startTalking() {
    _conversationController.startNewConversation();
    AppNavigator.pushRight(AppRoutes.chatbot);
  }

  /// Category card — direct Conversation with that topic
  void onCategoryTap(String title) {
    _conversationController.startNewConversation(withCategory: title);
    AppNavigator.pushRight(AppRoutes.conservation);
  }

  /// Recent card — open real conversation (same as History tile)
  void onRecentItemTap(RecentItem item) {
    final conv = _conversationController;
    conv.loadExistingConversation(
      item.conversationId,
      title: item.title,
      category: item.category,
    ).then((_) {
      Get.toNamed(AppRoutes.conservation);
    });
  }
}
