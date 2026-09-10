import 'dart:convert';
import 'package:get/get.dart';
import 'package:guyline/core/network/apiendpoints.dart';
import 'package:http/http.dart' as http;

class AuthService {


  // signup method

  Future<AuthResult> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.register);

    final Map<String, dynamic> body = {
      "username": username,
      "email": email,
      "password": password,
    };

    print("🔵 [AuthService] Calling REGISTER API");
    print("🔵 [AuthService] URL: $url");
    print("🔵 [AuthService] Request Body: $body");

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

      print("🟢 [AuthService] Status Code: ${response.statusCode}");
      print("🟢 [AuthService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult(
          success: true,
          message: decoded["message"] ?? "Registered successfully",
          user: decoded["user"] != null
              ? UserModel.fromJson(decoded["user"])
              : null,
        );
      } else {
        // Handle validation errors / server error messages
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Something went wrong. Please try again.";

        // Agar Laravel-style "errors" object aaye (field-wise errors)
        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return AuthResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [AuthService] Network Error: $e");
      return AuthResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [AuthService] Parsing Error: $e");
      return AuthResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [AuthService] Unexpected Error: $e");
      return AuthResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }


  // login method

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.login);

    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    print("🔵 [AuthService] Calling LOGIN API");
    print("🔵 [AuthService] URL: $url");
    print("🔵 [AuthService] Request Body: $body");

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

      print("🟢 [AuthService] Status Code: ${response.statusCode}");
      print("🟢 [AuthService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResult(
          success: true,
          message: decoded["message"] ?? "Login successful",
          user: decoded["user"] != null
              ? UserModel.fromJson(decoded["user"])
              : null,
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Invalid email or password.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return AuthResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [AuthService] Network Error: $e");
      return AuthResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [AuthService] Parsing Error: $e");
      return AuthResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [AuthService] Unexpected Error: $e");
      return AuthResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }

  // forget password method


  /// Sends a password reset code to the user's email
  /// Returns a [ForgotPasswordResult] containing user_id and otp on success
  Future<ForgotPasswordResult> forgotPassword({
    required String email,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.forgotPassword);

    final Map<String, dynamic> body = {
      "email": email,
    };

    print("🔵 [AuthService] Calling FORGOT PASSWORD API");
    print("🔵 [AuthService] URL: $url");
    print("🔵 [AuthService] Request Body: $body");

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

      print("🟢 [AuthService] Status Code: ${response.statusCode}");
      print("🟢 [AuthService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ForgotPasswordResult(
          success: true,
          message: decoded["message"] ?? "Verification code generated",
          userId: decoded["user_id"],
          otp: decoded["otp"],
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Unable to send verification code. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return ForgotPasswordResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [AuthService] Network Error: $e");
      return ForgotPasswordResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [AuthService] Parsing Error: $e");
      return ForgotPasswordResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [AuthService] Unexpected Error: $e");
      return ForgotPasswordResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }

  // resetpassword method

  Future<ResetPasswordResult> verifyAndResetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.verifyAndResetPassword);

    final Map<String, dynamic> body = {
      "email": email,
      "otp": otp,
      "password": password,
    };

    print("🔵 [AuthService] Calling VERIFY & RESET PASSWORD API");
    print("🔵 [AuthService] URL: $url");
    print("🔵 [AuthService] Request Body: $body");

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

      print("🟢 [AuthService] Status Code: ${response.statusCode}");
      print("🟢 [AuthService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ResetPasswordResult(
          success: true,
          message: decoded["message"] ?? "Password reset successful",
          userId: decoded["user_id"],
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Unable to reset password. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return ResetPasswordResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [AuthService] Network Error: $e");
      return ResetPasswordResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [AuthService] Parsing Error: $e");
      return ResetPasswordResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [AuthService] Unexpected Error: $e");
      return ResetPasswordResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }
  // ------------------------------------------------------------------
  // EDIT PROFILE
  // ------------------------------------------------------------------
  Future<AuthResult> editProfile({
    required int userId,
    required String username,
    String? profileImageBase64, // full data:image/...;base64,xxxx  OR null
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.editProfile);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "username": username,
    };

    if (profileImageBase64 != null && profileImageBase64.isNotEmpty) {
      body["profile_image"] = profileImageBase64;
    }

    print("🔵 [AuthService] Calling EDIT PROFILE API");
    print("🔵 [AuthService] URL: $url");
    print("🔵 [AuthService] Request Body: $body");

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
          .timeout(const Duration(seconds: 30));

      print("🟢 [AuthService] Status Code: ${response.statusCode}");
      print("🟢 [AuthService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult(
          success: true,
          message: decoded["message"] ?? "Profile updated successfully",
          user: decoded["user"] != null
              ? UserModel.fromJson(decoded["user"])
              : null,
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to update profile. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return AuthResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [AuthService] Network Error: $e");
      return AuthResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [AuthService] Parsing Error: $e");
      return AuthResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [AuthService] Unexpected Error: $e");
      return AuthResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }
  // ------------------------------------------------------------------
// CHANGE PASSWORD
// ------------------------------------------------------------------
  Future<AuthResult> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.changePassword);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "current_password": currentPassword,
      "new_password": newPassword,
    };

    print("🔵 [AuthService] Calling CHANGE PASSWORD API");
    print("🔵 [AuthService] URL: $url");
    print("🔵 [AuthService] Request Body: $body");

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

      print("🟢 [AuthService] Status Code: ${response.statusCode}");
      print("🟢 [AuthService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResult(
          success: true,
          message: decoded["message"] ?? "Password changed successfully",
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to change password. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return AuthResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [AuthService] Network Error: $e");
      return AuthResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [AuthService] Parsing Error: $e");
      return AuthResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [AuthService] Unexpected Error: $e");
      return AuthResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }
}


// login or sign up result

class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}


// forget password result

class ForgotPasswordResult {
  final bool success;
  final String message;
  final int? userId;
  final int? otp;

  ForgotPasswordResult({
    required this.success,
    required this.message,
    this.userId,
    this.otp,
  });
}

// resetpassword result
class ResetPasswordResult {
  final bool success;
  final String message;
  final int? userId;

  ResetPasswordResult({
    required this.success,
    required this.message,
    this.userId,
  });
}


// user model for all method

class UserModel {
  final int id;
  final String username;
  final String email;
  final String? profileImage;
  final List<String>? interests;
  final String? thinkingStyle;
  final bool? onboardingCompleted;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.interests,
    this.thinkingStyle,
    this.onboardingCompleted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      profileImage: json["profile_image"],
      interests: json["interests"] != null
          ? List<String>.from(json["interests"])
          : null,
      thinkingStyle: json["thinking_style"],
      onboardingCompleted: json["onboarding_completed"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "profile_image": profileImage,
      "interests": interests,
      "thinking_style": thinkingStyle,
      "onboarding_completed": onboardingCompleted,
    };
  }
}