/// -----------------------------------------------------------------------
/// PASSWORD RESET SESSION — temporary in-memory holder
/// Carries email & OTP across Forget Password -> Verify -> Change Password
/// screens. NOT persisted to disk; cleared once the flow completes.
/// -----------------------------------------------------------------------
class PasswordResetSession {
  static String? email;
  static String? otp;

  static void clear() {
    email = null;
    otp = null;
    print("🟣 [PasswordResetSession] Cleared");
  }
}