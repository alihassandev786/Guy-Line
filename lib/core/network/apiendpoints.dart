class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "https://guyline.digitalpreps.com/api";

  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String onboarding = "$baseUrl/onboarding";
  static const String forgotPassword = "$baseUrl/forgot-password";
  static const String verifyAndResetPassword = "$baseUrl/verify-and-reset-password";
  static const String editProfile = "$baseUrl/edit-profile";
  static const String changePassword = "$baseUrl/change-password";
}