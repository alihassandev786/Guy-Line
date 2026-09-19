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
  static const String updateThinkingStyle = "$baseUrl/update-thinking-style";
  static const String chatSend = "$baseUrl/chat/send";
  static String conversationDetail(int conversationId) =>
      "$baseUrl/conversations/$conversationId";
  static const String helpMeSayIt = "$baseUrl/chat/help-me-say-it";
  static const String helpMeDecide = "$baseUrl/chat/help-me-decide";
  static const String makeAPlan = "$baseUrl/chat/make-a-plan";
  static const String history = "$baseUrl/history";
  static const String notifications = "$baseUrl/notifications";
  static String notificationMarkRead(int id) => "$baseUrl/notifications/$id/mark-read";
  static const String notificationMarkAllRead = "$baseUrl/notifications/mark-all-read";
  static const String subscriptionPlan = "$baseUrl/subscription-plan";
  static const String subscribe = "$baseUrl/subscription/subscribe";
  static const String rateApp = "$baseUrl/rate-app";

  /// Support / Contact request — goes to admin panel
  static const String support = "$baseUrl/support";
}
