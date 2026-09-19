import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guyline/core/network/apiendpoints.dart';
import 'sessionmanager.dart';

class RateService {
  /// POST /api/rate-app
  /// Body: { user_id, rating, feedback }
  Future<RateResult> submitRating({
    required int rating,
    required String feedback,
  }) async {
    final user = SessionManager.instance.getUser();
    if (user == null) {
      return RateResult(success: false, message: "Please login first");
    }

    if (rating < 1 || rating > 5) {
      return RateResult(success: false, message: "Please select a valid rating");
    }

    final uri = Uri.parse(ApiEndpoints.rateApp);
    final body = {
      "user_id": user.id,
      "rating": rating,
      "feedback": feedback,
    };

    print("🔵 [RateService] Calling RATE APP API");
    print("🔵 URL: $uri");
    print("🔵 Body: $body");

    try {
      final response = await http
          .post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 20));

      print("🟢 Status: ${response.statusCode}");
      print("🟢 Body: ${response.body}");

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RateResult(
          success: true,
          message: (decoded is Map && decoded["message"] != null)
              ? decoded["message"].toString()
              : "Thank you for your feedback!",
        );
      } else {
        return RateResult(
          success: false,
          message: (decoded is Map && decoded["message"] != null)
              ? decoded["message"].toString()
              : "Failed to submit rating. Please try again.",
        );
      }
    } catch (e) {
      print("❌ [RateService] $e");
      return RateResult(
        success: false,
        message: "Something went wrong. Please check your connection.",
      );
    }
  }
}

class RateResult {
  final bool success;
  final String message;

  RateResult({required this.success, required this.message});
}
