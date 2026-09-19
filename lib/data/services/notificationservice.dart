import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guyline/core/network/apiendpoints.dart';
import 'sessionmanager.dart';

class NotificationService {
  /// GET /api/notifications?user_id=xx
  Future<NotificationListResult> getNotifications() async {
    final user = SessionManager.instance.getUser();
    if (user == null) {
      return NotificationListResult(success: false, message: "User not logged in");
    }

    final uri = Uri.parse(ApiEndpoints.notifications).replace(
      queryParameters: {"user_id": user.id.toString()},
    );

    print("🔵 [NotificationService] GET Notifications");
    print("🔵 URL: $uri");

    try {
      final response = await http
          .get(uri, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })
          .timeout(const Duration(seconds: 20));

      print("🟢 Status: ${response.statusCode}");
      print("🟢 Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> list = [];
        if (decoded is List) {
          list = decoded;
        } else if (decoded["data"] is List) {
          list = decoded["data"];
        } else if (decoded["notifications"] is List) {
          list = decoded["notifications"];
        }

        final items = list
            .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
            .toList();

        return NotificationListResult(
          success: true,
          message: "Loaded",
          notifications: items,
        );
      } else {
        return NotificationListResult(
          success: false,
          message: decoded["message"] ?? "Failed to load notifications",
        );
      }
    } catch (e) {
      print("❌ [NotificationService] $e");
      return NotificationListResult(success: false, message: "Something went wrong");
    }
  }

  /// POST /api/notifications/{id}/mark-read
  Future<bool> markAsRead(int notificationId) async {
    final user = SessionManager.instance.getUser();
    if (user == null) return false;

    final uri = Uri.parse(ApiEndpoints.notificationMarkRead(notificationId));

    print("🔵 [NotificationService] Mark Read #$notificationId");

    try {
      final response = await http
          .post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": user.id}),
      )
          .timeout(const Duration(seconds: 15));

      print("🟢 Mark Read Status: ${response.statusCode}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Mark Read error: $e");
      return false;
    }
  }

  /// POST /api/notifications/mark-all-read
  Future<bool> markAllAsRead() async {
    final user = SessionManager.instance.getUser();
    if (user == null) return false;

    final uri = Uri.parse(ApiEndpoints.notificationMarkAllRead);

    print("🔵 [NotificationService] Mark All Read");

    try {
      final response = await http
          .post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": user.id}),
      )
          .timeout(const Duration(seconds: 15));

      print("🟢 Mark All Status: ${response.statusCode}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Mark All error: $e");
      return false;
    }
  }
}

/// ---------------- Models ----------------

class AppNotification {
  final int id;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;
  final String? type; // optional

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
    this.type,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json["id"] ?? 0,
      title: json["title"] ?? json["subject"] ?? "Notification",
      subtitle: json["body"] ?? json["message"] ?? json["subtitle"] ?? "",
      time: json["time_ago"] ?? json["created_at"] ?? json["time"] ?? "",
      isRead: json["is_read"] == true || json["read_at"] != null,
      type: json["type"],
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      subtitle: subtitle,
      time: time,
      isRead: isRead ?? this.isRead,
      type: type,
    );
  }
}

class NotificationListResult {
  final bool success;
  final String message;
  final List<AppNotification> notifications;

  NotificationListResult({
    required this.success,
    required this.message,
    this.notifications = const [],
  });
}