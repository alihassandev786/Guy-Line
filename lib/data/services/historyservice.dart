import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guyline/core/network/apiendpoints.dart';
import 'sessionmanager.dart';

class HistoryService {
  /// GET /api/history?user_id=xx
  Future<HistoryResult> getHistory() async {
    final user = SessionManager.instance.getUser();
    if (user == null) {
      return HistoryResult(success: false, message: "User not logged in");
    }

    final uri = Uri.parse(ApiEndpoints.history).replace(
      queryParameters: {"user_id": user.id.toString()},
    );

    print("🔵 [HistoryService] Calling HISTORY API");
    print("🔵 [HistoryService] URL: $uri");

    try {
      final response = await http
          .get(uri, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })
          .timeout(const Duration(seconds: 20));

      print("🟢 [HistoryService] Status: ${response.statusCode}");
      print("🟢 [HistoryService] Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<HistoryConversation> items = [];
        final Map<String, List<HistoryConversation>> groups = {
          "Today": [],
          "Yesterday": [],
          "Previous 7 Days": [],
          "Older": [],
        };

        void addFromGroup(String label, dynamic group) {
          if (group is List) {
            for (var e in group) {
              if (e is Map<String, dynamic>) {
                final item = HistoryConversation.fromJson(e);
                items.add(item);
                groups[label]?.add(item);
              }
            }
          }
        }

        addFromGroup("Today", decoded["today"]);
        addFromGroup("Yesterday", decoded["yesterday"]);
        addFromGroup("Previous 7 Days", decoded["previous_7_days"]);
        addFromGroup("Older", decoded["older"]);

        // Agar flat list ho to bhi handle
        if (items.isEmpty) {
          if (decoded is List) {
            for (var e in decoded) {
              items.add(HistoryConversation.fromJson(e));
            }
          } else if (decoded["data"] is List) {
            for (var e in decoded["data"]) {
              items.add(HistoryConversation.fromJson(e));
            }
          }
        }

        return HistoryResult(
          success: true,
          message: "History loaded",
          conversations: items,
          groups: groups,
        );
      } else {
        return HistoryResult(
          success: false,
          message: decoded["message"] ?? "Failed to load history",
        );
      }
    } catch (e) {
      print("❌ [HistoryService] Exception: $e");
      return HistoryResult(success: false, message: "Something went wrong");
    }
  }

  /// GET /api/conversations/{id}?user_id=xx
  Future<ConversationDetailResult> getConversationDetail(int id) async {
    final user = SessionManager.instance.getUser();
    if (user == null) {
      return ConversationDetailResult(success: false, message: "User not logged in");
    }

    final uri = Uri.parse(ApiEndpoints.conversationDetail(id)).replace(
      queryParameters: {"user_id": user.id.toString()},
    );

    print("🔵 [HistoryService] Calling CONVERSATION DETAIL");
    print("🔵 [HistoryService] URL: $uri");

    try {
      final response = await http
          .get(uri, headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })
          .timeout(const Duration(seconds: 20));

      print("🟢 [HistoryService] Status: ${response.statusCode}");
      print("🟢 [HistoryService] Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ConversationDetailResult(
          success: true,
          message: "OK",
          data: decoded is Map<String, dynamic> ? decoded : {"data": decoded},
        );
      } else {
        return ConversationDetailResult(
          success: false,
          message: decoded["message"] ?? "Failed to load conversation",
        );
      }
    } catch (e) {
      print("❌ [HistoryService] Exception: $e");
      return ConversationDetailResult(success: false, message: "Something went wrong");
    }
  }
}

/// ---------------- Models ----------------

class HistoryConversation {
  final int id;
  final String? title;
  final String? category;
  final String? lastMessage;
  final String? createdAt;
  final String? updatedAt;
  final String? timeAgo;

  HistoryConversation({
    required this.id,
    this.title,
    this.category,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
    this.timeAgo,
  });

  factory HistoryConversation.fromJson(Map<String, dynamic> json) {
    return HistoryConversation(
      id: json["id"] ?? json["conversation_id"] ?? 0,
      title: json["title"],
      category: json["category"],
      lastMessage: json["last_message"] ?? json["preview"] ?? json["message"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      timeAgo: json["time_ago"] ?? json["updated_at"],
    );
  }
}

class HistoryResult {
  final bool success;
  final String message;
  final List<HistoryConversation> conversations;
  final Map<String, List<HistoryConversation>> groups;

  HistoryResult({
    required this.success,
    required this.message,
    this.conversations = const [],
    this.groups = const {},
  });
}

class ConversationDetailResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ConversationDetailResult({
    required this.success,
    required this.message,
    this.data,
  });
}
