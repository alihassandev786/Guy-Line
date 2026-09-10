import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';

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
  final String title;
  final String subtitle;

  RecentItem({
    required this.title,
    required this.subtitle,
  });
}

class HomeController extends GetxController {
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

  final RxList<RecentItem> recentItems = <RecentItem>[
    RecentItem(
      title: "Handling the promotion..",
      subtitle: "Work . Yesterday",
    ),
    RecentItem(
      title: "Budgeting for the house..",
      subtitle: "Money . 3 days ago",
    ),
  ].obs;

  void startTalking() {
    AppNavigator.pushRight(AppRoutes.chatbot);
  }

  void onCategoryTap(String title) {
    // TODO: Handle Category Tap
  }

  void onRecentItemTap(RecentItem item) {
    // TODO: Open Recent History Detail
  }
}