import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
import '../services/intrectionprefrenceservice.dart';
import '../services/sessionmanager.dart';

class InteractionOption {
  final String title;
  final String subtitle;
  final IconData icon;

  InteractionOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class InteractionPreferenceController extends GetxController {
  final InteractionPreferenceService _interactionPreferenceService =
  InteractionPreferenceService();

  final selectedIndex = 0.obs;
  final isLoading = false.obs;

  final options = <InteractionOption>[
    InteractionOption(
      title: "Listen",
      subtitle: "Act as a sounding board",
      icon: Icons.graphic_eq_rounded,
    ),
    InteractionOption(
      title: "Be Straightforward",
      subtitle: "Direct and efficient",
      icon: Icons.graphic_eq_rounded,
    ),
    InteractionOption(
      title: "Challenge My Thinking",
      subtitle: "Push boundaries, offer alternative",
      icon: Icons.graphic_eq_rounded,
    ),
    InteractionOption(
      title: "Help Me Make Decisions",
      subtitle: "Structured analysis and pros/cons",
      icon: Icons.graphic_eq_rounded,
    ),
  ];

  /// Backend values, same order as `options`, matching Onboardingscreen.
  final List<String> thinkingStyleValues = const [
    "listen",
    "straightforward",
    "challenge",
    "decide",
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCurrentPreference();
  }

  void _loadCurrentPreference() {
    final currentStyle = SessionManager.instance.getUser()?.thinkingStyle;
    if (currentStyle == null) return;

    // Legacy value "decisions" → map to "decide"
    final normalized =
    currentStyle == "decisions" ? "decide" : currentStyle;

    final index = thinkingStyleValues.indexOf(normalized);
    if (index != -1) {
      selectedIndex.value = index;
    }
  }

  void selectOption(int index) {
    selectedIndex.value = index;
  }

  Future<void> saveChanges() async {
    final currentUser = SessionManager.instance.getUser();

    if (currentUser == null) {
      SnackbarService.error("User session not found. Please login again.");
      return;
    }

    final String selectedStyle = thinkingStyleValues[selectedIndex.value];

    isLoading.value = true;

    final result = await _interactionPreferenceService.updateThinkingStyle(
      userId: currentUser.id,
      thinkingStyle: selectedStyle,
    );

    isLoading.value = false;

    if (result.success) {
      await SessionManager.instance.updateThinkingStyle(
        result.thinkingStyle ?? selectedStyle,
      );

      SnackbarService.success(result.message);

      AppNavigator.pushAndClear(AppRoutes.bottomnavigation);
    } else {
      SnackbarService.error(result.message);
    }
  }
}