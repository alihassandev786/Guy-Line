import 'dart:convert';
import 'package:guyline/core/network/apiendpoints.dart';
import 'package:http/http.dart' as http;
import 'authservice.dart';

/// -----------------------------------------------------------------------
/// ONBOARDING SERVICE — handles onboarding completion API call
/// -----------------------------------------------------------------------
class OnboardingService {
  /// Submits user's selected interests & thinking style
  /// Returns an [AuthResult] containing success flag, message, and updated user data
  Future<AuthResult> completeOnboarding({
    required int userId,
    required List<String> interests,
    required String thinkingStyle,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.onboarding);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "interests": interests,
      "thinking_style": thinkingStyle,
    };

    print("🔵 [OnboardingService] Calling ONBOARDING API");
    print("🔵 [OnboardingService] URL: $url");
    print("🔵 [OnboardingService] Request Body: $body");

    try {
      final response = await http
          .post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 20));

      print("🟢 [OnboardingService] Status Code: ${response.statusCode}");
      print("🟢 [OnboardingService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult(
          success: true,
          message: decoded["message"] ?? "Onboarding completed successfully",
          user: decoded["user"] != null
              ? UserModel.fromJson(decoded["user"])
              : null,
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Something went wrong. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return AuthResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [OnboardingService] Network Error: $e");
      return AuthResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [OnboardingService] Parsing Error: $e");
      return AuthResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [OnboardingService] Unexpected Error: $e");
      return AuthResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }
}