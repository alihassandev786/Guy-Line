import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/data/controllers/profilecontroller.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
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
SnackbarService.error("Please fill all fields");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      SnackbarService.error("Please enter a valid email address");
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
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().refreshFromSession();
      } else {
        Get.put(ProfileController(), permanent: true).refreshFromSession();
      }

      SnackbarService.success(result.message);

      AppNavigator.pushAndClear(AppRoutes.bottomnavigation);
    } else {
      print("❌ [LoginController] Login failed: ${result.message}");
      SnackbarService.error(result.message);
    }
  }
  @override
  void onClose() {
    super.onClose();
  }
}