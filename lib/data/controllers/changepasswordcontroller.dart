import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import '../services/authservice.dart';
import '../services/passwordresetsession.dart';

class ChangePasswordController extends GetxController {
  final AuthService _authService = AuthService();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> createPassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    // ---- Validation ----
    if (newPass.isEmpty || confirmPass.isEmpty) {
      _showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (newPass.length < 6) {
      _showSnackbar("Weak Password", "Password must be at least 6 characters", isError: true);
      return;
    }

    if (newPass != confirmPass) {
      _showSnackbar("Mismatch", "New password and confirm password do not match", isError: true);
      return;
    }

    final String? email = PasswordResetSession.email;
    final String? otp = PasswordResetSession.otp;

    if (email == null || otp == null) {
      _showSnackbar(
        "Error",
        "Session expired. Please restart the forgot password process.",
        isError: true,
      );
      return;
    }

    // ---- API Call ----
    isLoading.value = true;
    print("🟡 [ChangePasswordController] Resetting password for: $email");

    final result = await _authService.verifyAndResetPassword(
      email: email,
      otp: otp,
      password: newPass,
    );

    isLoading.value = false;

    if (result.success) {
      print(
        "✅ [ChangePasswordController] Password reset successful. "
            "user_id: ${result.userId}",
      );

      // Keyboard close before changing screen
      FocusManager.instance.primaryFocus?.unfocus();

      // Clear temporary reset data
      PasswordResetSession.clear();

      _showSnackbar(
        "Success",
        result.message,
        isError: false,
      );

      AppNavigator.pushRight(AppRoutes.success);
    } else {
      print("❌ [ChangePasswordController] Reset failed: ${result.message}");
      _showSnackbar("Error", result.message, isError: true);
    }
  }

  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(
          () => ChangePasswordController(),
      fenix: true,
    );
  }
}