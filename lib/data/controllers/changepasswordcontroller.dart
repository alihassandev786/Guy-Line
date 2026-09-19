import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
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
      SnackbarService.error("Please fill all fields");
      return;
    }

    if (newPass.length < 6) {
      SnackbarService.error("Password must be at least 6 characters");
      return;
    }

    if (newPass != confirmPass) {
      SnackbarService.error("New password and confirm password do not match");

      return;
    }

    final String? email = PasswordResetSession.email;
    final String? otp = PasswordResetSession.otp;

    if (email == null || otp == null) {
      SnackbarService.error(
        "Session expired. Please restart the forgot password process.",
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

      SnackbarService.success(result.message);

      AppNavigator.pushRight(AppRoutes.success);
    } else {
      print("❌ [ChangePasswordController] Reset failed: ${result.message}");
      SnackbarService.error(result.message);
    }
  }
  @override
  void onClose() {
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
