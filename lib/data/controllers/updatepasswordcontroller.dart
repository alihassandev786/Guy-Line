import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
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
      _showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (newPass.length < 6) {
      _showSnackbar(
        "Weak Password",
        "New password must be at least 6 characters",
        isError: true,
      );
      return;
    }

    if (newPass != confirmPass) {
      _showSnackbar(
        "Mismatch",
        "New password and confirm password do not match",
        isError: true,
      );
      return;
    }

    if (currentPass == newPass) {
      _showSnackbar(
        "Error",
        "New password cannot be same as current password",
        isError: true,
      );
      return;
    }

    // ---------- Get current user id ----------
    final user = SessionManager.instance.getUser();
    if (user == null) {
      _showSnackbar(
        "Error",
        "User session not found. Please login again.",
        isError: true,
      );
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

      _showSnackbar("Success", result.message, isError: false);

      // Optional: go back or to success screen
      AppNavigator.pushRight(AppRoutes.bottomnavigation);
    } else {
      print("❌ [UpdatePasswordController] Failed: ${result.message}");
      _showSnackbar("Failed", result.message, isError: true);
    }
  }

  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}