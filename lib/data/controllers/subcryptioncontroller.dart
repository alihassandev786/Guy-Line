import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
import '../services/subcryptionservice.dart';
import '../services/sessionmanager.dart';

class SubscriptionController extends GetxController {
  final SubscriptionService _service = SubscriptionService();

  final isLoading = false.obs;
  final isSubscribing = false.obs;
  final errorMessage = "".obs;

  final plans = <SubscriptionPlan>[].obs;
  final selectedPlanId = 0.obs;

  // Card input (simple for now)
  final cardNumberController = TextEditingController();

  // Fallback UI values (jab tak API se data na aaye)
  final price = "\$19.99".obs;
  final period = "/month".obs;
  final features = <String>[
    "Unlimited private conversations",
    "Advanced emotional intelligence models",
    "Absolute data privacy guarantee",
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadPlans();
  }

  Future<void> loadPlans() async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await _service.getPlans();

    isLoading.value = false;

    if (result.success && result.plans.isNotEmpty) {
      plans.assignAll(result.plans);
      final first = result.plans.first;
      selectedPlanId.value = first.id;
      price.value = first.price;
      period.value = first.period;
      if (first.features.isNotEmpty) {
        features.assignAll(first.features);
      }
      print("✅ [SubscriptionController] Loaded ${plans.length} plans");
    } else {
      errorMessage.value = result.message;
      print("❌ [SubscriptionController] ${result.message}");
    }
  }

  void selectPlan(SubscriptionPlan plan) {
    selectedPlanId.value = plan.id;
    price.value = plan.price;
    period.value = plan.period;
    if (plan.features.isNotEmpty) {
      features.assignAll(plan.features);
    }
  }

  Future<void> subscribeNow() async {
    if (SessionManager.instance.getUser() == null) {
      _showError("Please login first");
      return;
    }

    if (selectedPlanId.value == 0 && plans.isNotEmpty) {
      selectedPlanId.value = plans.first.id;
    }

    if (selectedPlanId.value == 0) {
      _showError("No plan selected");
      return;
    }

    final card = cardNumberController.text.trim();
    if (card.isEmpty) {
      // Agar screen pe card field nahi hai to test ke liye dummy use
      // Production mein card field add karna better hai
    }

    isSubscribing.value = true;

    final result = await _service.subscribe(
      planId: selectedPlanId.value,
      cardNumber: card.isEmpty ? "4242424242424242" : card, // test card
    );

    isSubscribing.value = false;

    if (result.success) {
      SnackbarService.success(result.message);
    } else {
      _showError(result.message);
    }
  }

  void _showError(String msg) {
    SnackbarService.error(msg);
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    super.onClose();
  }
}