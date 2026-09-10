import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/authservice.dart';
import '../services/sessionmanager.dart';
import '../../presentation/Widgets/AppNavigator.dart';
import '../../core/routes/approutes.dart';


class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  var isObscurePassword = true.obs;
  var rememberMe = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login() async {
    final String email = usernameController.text.trim();
    final String password = passwordController.text.trim();

    // ---- Validation ----
    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showSnackbar("Error", "Please enter a valid email address", isError: true);
      return;
    }

    // ---- API Call ----
    isLoading.value = true;
    print("🟡 [LoginController] Attempting login for: $email");

    final AuthResult result = await _authService.login(
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (result.success && result.user != null) {
      print("✅ [LoginController] Login successful: ${result.user!.username}");

      // Save session locally
      await SessionManager.instance.saveUser(result.user!);

      _showSnackbar("Success", result.message, isError: false);

      AppNavigator.pushRight(AppRoutes.bottomnavigation);
    } else {
      print("❌ [LoginController] Login failed: ${result.message}");
      _showSnackbar("Login Failed", result.message, isError: true);
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
    passwordController.dispose();
    super.onClose();
  }
}