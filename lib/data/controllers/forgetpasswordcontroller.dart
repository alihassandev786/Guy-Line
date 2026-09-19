import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/data/services/passwordresetsession.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
import '../../core/routes/approutes.dart';
import '../../presentation/Widgets/AppNavigator.dart';
import '../services/authservice.dart';

class ForgetPasswordController extends GetxController {
  final AuthService _authService = AuthService();

  late TextEditingController emailController;

  var isLoading = false.obs;

  /// Saved temporarily after a successful "send code" call,
  /// so the Verify screen can use them later.
  int? userId;
  int? otp;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  Future<void> sendCode() async {
    final String email = emailController.text.trim();

    // Validation
    if (email.isEmpty) {
      SnackbarService.error("Please enter your email adress");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      SnackbarService.error("Please enter a valid email address");
      return;
    }

    // Prevent multiple taps
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      print("🟡 [ForgetPasswordController] Sending code to: $email");

      final result = await _authService.forgotPassword(email: email);

      print("🟡 [ForgetPasswordController] API completed");
      print("🟡 Success: ${result.success}");
      print("🟡 Message: ${result.message}");
      print("🟡 User ID: ${result.userId}");
      print("🟡 OTP: ${result.otp}");

      if (result.success) {
        userId = result.userId;
        otp = result.otp;

        // Very important
        PasswordResetSession.email = email;

        print("✅ [ForgetPasswordController] Code sent successfully to: $email");

        SnackbarService.success(result.message);

        // Navigate ONLY after successful API response
        AppNavigator.pushRight(AppRoutes.verify);
      } else {
        print("❌ [ForgetPasswordController] Failed: ${result.message}");

        SnackbarService.error(result.message);
      }
    } catch (e, stackTrace) {
      print("❌ [ForgetPasswordController] Exception: $e");
      print("❌ StackTrace: $stackTrace");

      SnackbarService.error("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    print("🟣 [ForgetPasswordBinding] Registering ForgetPasswordController");
    Get.lazyPut<ForgetPasswordController>(() => ForgetPasswordController());
  }
}
