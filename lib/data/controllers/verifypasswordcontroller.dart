import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
import '../services/authservice.dart';
import '../services/passwordresetsession.dart';

class VerifyController extends GetxController {
  final AuthService _authService = AuthService();

  final otpController = TextEditingController();

  var isLoading = false.obs;

  /// Validates the entered OTP locally and stores it for the final
  /// verify-and-reset-password call (which happens on Change Password screen,
  /// since the backend combines OTP verification + password reset in one API).
  bool verifyCode() {
    final String enteredOtp = otpController.text.trim();

    if (enteredOtp.isEmpty) {
      SnackbarService.error("Please enter the verification code");
      return false;
    }

    if (enteredOtp.length != 6) {
      SnackbarService.error("Please enter the complete 6-digit code");
      return false;
    }

    print("🟡 [VerifyController] OTP entered: $enteredOtp");

    // Save OTP for final reset API
    PasswordResetSession.otp = enteredOtp;

    print(
      "✅ [VerifyController] OTP stored in PasswordResetSession",
    );

    return true;
  }
  /// Resends the OTP by calling forgot-password API again
  Future<void> resendCode() async {
    final String? email = PasswordResetSession.email;

    if (email == null || email.isEmpty) {
      SnackbarService.error("Session expired. Please restart the forgot password process.");
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      print("🟡 [VerifyController] Resending code to: $email");

      final result = await _authService.forgotPassword(
        email: email,
      );

      print("🟡 [VerifyController] Resend success: ${result.success}");
      print("🟡 [VerifyController] Resend message: ${result.message}");

      if (result.success) {
        print("✅ [VerifyController] Code resent successfully");

        SnackbarService.success(result.message.isNotEmpty
            ? result.message
            : "A new code has been sent to your email",);
      } else {
        print(
          "❌ [VerifyController] Resend failed: ${result.message}",
        );

        SnackbarService.error(result.message);
      }
    } catch (e, stackTrace) {
      print("❌ [VerifyController] Resend exception: $e");
      print(stackTrace);

     SnackbarService.error("Unable to resend code. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}

/// -----------------------------------------------------------------------
/// VERIFY BINDING — registers VerifyController before Verify screen loads
/// -----------------------------------------------------------------------
class VerifyBinding extends Bindings {
  @override
  void dependencies() {
    print("🟣 [VerifyBinding] Registering VerifyController");
    Get.lazyPut<VerifyController>(() => VerifyController(), fenix: true);
  }
}