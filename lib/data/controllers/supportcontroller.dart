import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/data/services/sessionmanager.dart';
import 'package:guyline/data/services/supportservice.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';

class SupportController extends GetxController {
  final SupportService _service = SupportService();

  final messageController = TextEditingController();
  final subjectController = TextEditingController();
  final isSubmitting = false.obs;

  Future<void> submitRequest() async {
    if (SessionManager.instance.getUser() == null) {
      _showError("Please login first");
      return;
    }

    final message = messageController.text.trim();
    if (message.isEmpty) {
      _showError("Please write your message");
      return;
    }

    if (message.length < 10) {
      _showError("Message is too short. Please describe your issue.");
      return;
    }

    isSubmitting.value = true;

    final result = await _service.submitRequest(
      message: message,
      subject: subjectController.text.trim().isEmpty
          ? null
          : subjectController.text.trim(),
    );

    isSubmitting.value = false;

    if (result.success) {
      messageController.clear();
      subjectController.clear();

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
    messageController.dispose();
    subjectController.dispose();
    super.onClose();
  }
}
