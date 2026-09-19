import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/Widgets/snackbar.dart';
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
      SnackbarService.error("Please fill all fields");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      SnackbarService.error("Please enter a valid email address");
      return;
    }
// Professional password rules
    if (password.length < 8) {
      SnackbarService.error("Password must be at least 8 characters");

      return;
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      SnackbarService.error("Password must contain at least one uppercase letter");

      return;
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      SnackbarService.error("Password must contain at least one lowercase letter");
      return;
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      SnackbarService.error("Password must contain at least one number");

      return;
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      SnackbarService.error("Password must contain at least one special character (!@#\$%^&*)");

      return;
    }
    if (password != confirmPassword) {
      SnackbarService.error("Passwords do not match");
      return;
    }

    if (!isAgreed.value) {
      SnackbarService.error("Please agree to terms & conditions");
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

      SnackbarService.success(result.message);

      AppNavigator.pushRight(AppRoutes.bottomnavigation);
    } else {
      print("❌ [SignupController] Signup failed: ${result.message}");
      SnackbarService.error(result.message);
    }
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