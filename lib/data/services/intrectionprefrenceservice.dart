import 'dart:convert';
import 'package:guyline/core/network/apiendpoints.dart';
import 'package:http/http.dart' as http;

/// -----------------------------------------------------------------------
/// INTERACTION PREFERENCE SERVICE — handles update-thinking-style API call
/// -----------------------------------------------------------------------
class InteractionPreferenceService {
  /// Updates the user's thinking style / interaction preference.
  /// Returns a [ThinkingStyleResult] containing success flag, message,
  /// and the confirmed thinking_style value from the backend.
  Future<ThinkingStyleResult> updateThinkingStyle({
    required int userId,
    required String thinkingStyle,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.updateThinkingStyle);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "thinking_style": thinkingStyle,
    };

    print("🔵 [InteractionPreferenceService] Calling UPDATE THINKING STYLE API");
    print("🔵 [InteractionPreferenceService] URL: $url");
    print("🔵 [InteractionPreferenceService] Request Body: $body");

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

      print("🟢 [InteractionPreferenceService] Status Code: ${response.statusCode}");
      print("🟢 [InteractionPreferenceService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ThinkingStyleResult(
          success: true,
          message: decoded["message"] ?? "Interaction preference updated successfully",
          thinkingStyle: decoded["thinking_style"] ?? thinkingStyle,
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to update interaction preference. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return ThinkingStyleResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [InteractionPreferenceService] Network Error: $e");
      return ThinkingStyleResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [InteractionPreferenceService] Parsing Error: $e");
      return ThinkingStyleResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [InteractionPreferenceService] Unexpected Error: $e");
      return ThinkingStyleResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }
}

/// update thinking style result
class ThinkingStyleResult {
  final bool success;
  final String message;
  final String? thinkingStyle;

  ThinkingStyleResult({
    required this.success,
    required this.message,
    this.thinkingStyle,
  });
}