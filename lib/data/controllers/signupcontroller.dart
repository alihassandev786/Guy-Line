import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/authservice.dart';
import '../services/sessionmanager.dart';
import '../../presentation/Widgets/AppNavigator.dart';
import '../../core/routes/approutes.dart';

class SignupController extends GetxController {
  final AuthService _authService = AuthService();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isObscurePassword = true.obs;
  var isObscureConfirmPassword = true.obs;
  var isAgreed = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    isObscureConfirmPassword.value = !isObscureConfirmPassword.value;
  }

  void toggleAgree() {
    isAgreed.value = !isAgreed.value;
  }

  Future<void> signup() async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    // ---- Validation ----
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showSnackbar("Error", "Please enter a valid email address", isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackbar("Error", "Password must be at least 6 characters", isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Error", "Passwords do not match", isError: true);
      return;
    }

    if (!isAgreed.value) {
      _showSnackbar("Warning", "Please agree to terms & conditions", isError: false);
      return;
    }

    // ---- API Call ----
    isLoading.value = true;
    print("🟡 [SignupController] Starting signup for: $username / $email");

    final AuthResult result = await _authService.register(
      username: username,
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (result.success && result.user != null) {
      print("✅ [SignupController] Signup successful: ${result.user!.username}");

      // Save session locally
      await SessionManager.instance.saveUser(result.user!);

      _showSnackbar("Success", result.message, isError: false);

      AppNavigator.pushRight(AppRoutes.bottomnavigation);
    } else {
      print("❌ [SignupController] Signup failed: ${result.message}");
      _showSnackbar("Signup Failed", result.message, isError: true);
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}