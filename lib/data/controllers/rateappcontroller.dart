import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/data/services/sessionmanager.dart';
import '../../presentation/Widgets/snackbar.dart';
import '../services/rateappservice.dart';

class RateAppController extends GetxController {
  final RateService _service = RateService();

  final rating = 0.obs;
  final isSubmitting = false.obs;
  final feedbackController = TextEditingController();

  void setRating(int value) {
    if (isSubmitting.value) return;
    rating.value = value;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;

    if (SessionManager.instance.getUser() == null) {
      _showError("Please login first");
      return;
    }

    if (rating.value < 1 || rating.value > 5) {
      _showError("Please select a star rating");
      return;
    }

    isSubmitting.value = true;

    final result = await _service.submitRating(
      rating: rating.value,
      feedback: feedbackController.text.trim(),
    );

    isSubmitting.value = false;

    if (result.success) {
      // Reset form
      rating.value = 0;
      feedbackController.clear();

      SnackbarService.success(result.message);


      // Optional: go back after short delay
      Future.delayed(const Duration(milliseconds: 800), () {
        if (Get.isSnackbarOpen != true) {
          // keep user on screen so they see snackbar; they can press back
        }
      });
    } else {
      _showError(result.message);
    }
  }

  void _showError(String msg) {
    SnackbarService.error(msg);

  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
