import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/data/services/passwordresetsession.dart';
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
      _showSnackbar(
        "Error",
        "Please enter your email address",
        isError: true,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showSnackbar(
        "Error",
        "Please enter a valid email address",
        isError: true,
      );
      return;
    }

    // Prevent multiple taps
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      print("🟡 [ForgetPasswordController] Sending code to: $email");

      final result = await _authService.forgotPassword(
        email: email,
      );

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

        print(
          "✅ [ForgetPasswordController] Code sent successfully to: $email",
        );

        _showSnackbar(
          "Success",
          result.message,
          isError: false,
        );

        // Navigate ONLY after successful API response
        AppNavigator.pushRight(AppRoutes.verify);
      } else {
        print(
          "❌ [ForgetPasswordController] Failed: ${result.message}",
        );

        _showSnackbar(
          "Error",
          result.message,
          isError: true,
        );
      }
    } catch (e, stackTrace) {
      print("❌ [ForgetPasswordController] Exception: $e");
      print("❌ StackTrace: $stackTrace");

      _showSnackbar(
        "Error",
        "Something went wrong. Please try again.",
        isError: true,
      );
    } finally {
      isLoading.value = false;
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
    emailController.dispose();
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