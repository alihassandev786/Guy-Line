import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import '../../presentation/Widgets/snackbar.dart';
import '../services/authservice.dart';
import '../services/sessionmanager.dart';

class UpdatePasswordController extends GetxController {
  final AuthService _authService = AuthService();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> updatePassword() async {
    final String currentPass = currentPasswordController.text.trim();
    final String newPass = newPasswordController.text.trim();
    final String confirmPass = confirmPasswordController.text.trim();

    // ---------- Validation ----------
    if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      SnackbarService.error("Please fill all fields");
      return;
    }

    if (newPass.length < 6) {
      SnackbarService.error("New password must be at least 6 characters");

      return;
    }

    if (newPass != confirmPass) {
      SnackbarService.error("New password and confirm password do not match");

      return;
    }

    if (currentPass == newPass) {
      SnackbarService.error("New password cannot be same as current password");

      return;
    }

    // ---------- Get current user id ----------
    final user = SessionManager.instance.getUser();
    if (user == null) {
      SnackbarService.error("User session not found. Please login again.");

      return;
    }

    // ---------- API Call ----------
    isLoading.value = true;
    print("🟡 [UpdatePasswordController] Changing password for userId: ${user.id}");

    final AuthResult result = await _authService.changePassword(
      userId: user.id,
      currentPassword: currentPass,
      newPassword: newPass,
    );

    isLoading.value = false;

    if (result.success) {
      print("✅ [UpdatePasswordController] Password changed successfully");

      // Clear fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      SnackbarService.success(result.message);

      // Optional: go back or to success screen
      AppNavigator.pushRight(AppRoutes.bottomnavigation);
    } else {
      print("❌ [UpdatePasswordController] Failed: ${result.message}");
      SnackbarService.error(result.message);
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}