import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guyline/core/network/apiendpoints.dart';
import 'sessionmanager.dart';

class SupportService {
  /// POST /api/support
  /// Body: { user_id, subject?, message }
  Future<SupportResult> submitRequest({
    required String message,
    String? subject,
  }) async {
    final user = SessionManager.instance.getUser();
    if (user == null) {
      return SupportResult(success: false, message: "Please login first");
    }

    final uri = Uri.parse(ApiEndpoints.support);
    final body = <String, dynamic>{
      "user_id": user.id,
      "message": message,
      if (subject != null && subject.trim().isNotEmpty) "subject": subject.trim(),
    };

    print("🔵 [SupportService] Calling SUPPORT API");
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
        return SupportResult(
          success: true,
          message: (decoded is Map && decoded["message"] != null)
              ? decoded["message"].toString()
              : "Your request has been submitted. We'll get back to you soon.",
        );
      } else {
        return SupportResult(
          success: false,
          message: (decoded is Map && decoded["message"] != null)
              ? decoded["message"].toString()
              : "Failed to submit request. Please try again.",
        );
      }
    } catch (e) {
      print("❌ [SupportService] $e");
      return SupportResult(
        success: false,
        message: "Something went wrong. Please check your connection.",
      );
    }
  }
}

class SupportResult {
  final bool success;
  final String message;

  SupportResult({required this.success, required this.message});
}
