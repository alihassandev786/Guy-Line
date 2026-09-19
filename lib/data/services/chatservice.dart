import 'dart:convert';
import 'package:guyline/core/network/apiendpoints.dart';
import 'package:http/http.dart' as http;

/// -----------------------------------------------------------------------
/// CHAT SERVICE — handles sending chat messages & fetching a conversation.
/// Used by BOTH Chatbot.dart (starts a conversation) and
/// Conservation.dart (continues an existing conversation).
/// -----------------------------------------------------------------------
class ChatService {
  /// Sends a message to the AI. If [conversationId] is null, backend is
  /// expected to start a brand-new conversation and return its id.
  Future<ChatSendResult> sendMessage({
    required int userId,
    required String message,
    required String category,
    int? conversationId,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.chatSend);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "message": message,
      "category": category,
    };

    if (conversationId != null) {
      body["conversation_id"] = conversationId;
    }

    print("🔵 [ChatService] Calling CHAT SEND API");
    print("🔵 [ChatService] URL: $url");
    print("🔵 [ChatService] Request Body: $body");

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

      print("🟢 [ChatService] Status Code: ${response.statusCode}");
      print("🟢 [ChatService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatSendResult(
          success: true,
          message: decoded["message"] ?? "Message sent",
          conversationId: decoded["conversation_id"],
          reply: decoded["reply"] ?? "",
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to send message. Please try again.";

        if (decoded["errors"] != null && decoded["errors"] is Map) {
          final errors = decoded["errors"] as Map;
          errorMessage = errors.values
              .expand((e) => e is List ? e : [e])
              .join("\n");
        }

        return ChatSendResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [ChatService] Network Error: $e");
      return ChatSendResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [ChatService] Parsing Error: $e");
      return ChatSendResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [ChatService] Unexpected Error: $e");
      return ChatSendResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }

  /// Fetches full conversation (details + messages) for the given id.
  Future<ConversationResult> getConversation({
    required int conversationId,
    required int userId,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.conversationDetail(conversationId))
        .replace(queryParameters: {"user_id": userId.toString()});

    print("🔵 [ChatService] Calling GET CONVERSATION API");
    print("🔵 [ChatService] URL: $url");

    try {
      final response = await http
          .get(url, headers: {"Accept": "application/json"})
          .timeout(const Duration(seconds: 20));

      print("🟢 [ChatService] Status Code: ${response.statusCode}");
      print("🟢 [ChatService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final conversationJson = decoded["conversation"];
        final messagesJson = decoded["messages"] as List<dynamic>? ?? [];

        return ConversationResult(
          success: true,
          message: decoded["message"] ?? "Conversation fetched successfully",
          conversation: conversationJson != null
              ? ConversationModel.fromJson(conversationJson)
              : null,
          messages:
          messagesJson.map((m) => ChatMessageModel.fromJson(m)).toList(),
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to load conversation. Please try again.";
        return ConversationResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [ChatService] Network Error: $e");
      return ConversationResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [ChatService] Parsing Error: $e");
      return ConversationResult(
        success: false,
        message: "Invalid response from server.",
      );
    } catch (e) {
      print("🔴 [ChatService] Unexpected Error: $e");
      return ConversationResult(
        success: false,
        message: "Unexpected error occurred. Please try again.",
      );
    }
  }

  // ------------------------------------------------------------------
  // HELP ME SAY IT
  // ------------------------------------------------------------------
  Future<HelpMeSayItResult> helpMeSayIt({
    required int userId,
    required int conversationId,
    required String recipientName,
    required String tone,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.helpMeSayIt);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "conversation_id": conversationId,
      "recipient_name": recipientName,
      "tone": tone,
    };

    print("🔵 [ChatService] Calling HELP ME SAY IT API");
    print("🔵 [ChatService] URL: $url");
    print("🔵 [ChatService] Request Body: $body");

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

      print("🟢 [ChatService] Status Code: ${response.statusCode}");
      print("🟢 [ChatService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HelpMeSayItResult(
          success: true,
          message: decoded["message"] ?? "Draft generated successfully",
          draft: decoded["draft"],
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to generate draft. Please try again.";
        return HelpMeSayItResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [ChatService] Network Error: $e");
      return HelpMeSayItResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [ChatService] Parsing Error: $e");
      return HelpMeSayItResult(
          success: false, message: "Invalid response from server.");
    } catch (e) {
      print("🔴 [ChatService] Unexpected Error: $e");
      return HelpMeSayItResult(
          success: false,
          message: "Unexpected error occurred. Please try again.");
    }
  }

  // ------------------------------------------------------------------
  // HELP ME DECIDE
  // ------------------------------------------------------------------
  Future<HelpMeDecideResult> helpMeDecide({
    required int userId,
    required int conversationId,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.helpMeDecide);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "conversation_id": conversationId,
    };

    print("🔵 [ChatService] Calling HELP ME DECIDE API");
    print("🔵 [ChatService] URL: $url");
    print("🔵 [ChatService] Request Body: $body");

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

      print("🟢 [ChatService] Status Code: ${response.statusCode}");
      print("🟢 [ChatService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decisionJson = decoded["decision"];

        String summary = "";
        List<DecideOptionModel> options = [];

        if (decisionJson is Map) {
          summary = decisionJson["summary"]?.toString() ?? "";

          // option_a, option_b, option_c ... ko dynamically parse karo
          decisionJson.forEach((key, value) {
            if (key.toString().toLowerCase().startsWith("option_") &&
                value is Map) {
              final title = value["title"]?.toString() ?? key.toString();
              final pros = (value["pros"] is List)
                  ? List<String>.from(
                  (value["pros"] as List).map((e) => e.toString()))
                  : <String>[];
              final cons = (value["cons"] is List)
                  ? List<String>.from(
                  (value["cons"] as List).map((e) => e.toString()))
                  : <String>[];

              options.add(DecideOptionModel(
                title: title,
                subtitle: "",
                pros: pros,
                cons: cons,
              ));
            }
          });
        }

        return HelpMeDecideResult(
          success: true,
          message: decoded["message"] ?? "Decision analysis generated successfully",
          summary: summary,
          options: options,
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to generate decision analysis. Please try again.";
        return HelpMeDecideResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [ChatService] Network Error: $e");
      return HelpMeDecideResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [ChatService] Parsing Error: $e");
      return HelpMeDecideResult(
          success: false, message: "Invalid response from server.");
    } catch (e) {
      print("🔴 [ChatService] Unexpected Error: $e");
      return HelpMeDecideResult(
          success: false,
          message: "Unexpected error occurred. Please try again.");
    }
  }

  // ------------------------------------------------------------------
  // MAKE A PLAN
  // ------------------------------------------------------------------
  Future<MakeAPlanResult> makeAPlan({
    required int userId,
    required int conversationId,
  }) async {
    final Uri url = Uri.parse(ApiEndpoints.makeAPlan);

    final Map<String, dynamic> body = {
      "user_id": userId,
      "conversation_id": conversationId,
    };

    print("🔵 [ChatService] Calling MAKE A PLAN API");
    print("🔵 [ChatService] URL: $url");
    print("🔵 [ChatService] Request Body: $body");

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

      print("🟢 [ChatService] Status Code: ${response.statusCode}");
      print("🟢 [ChatService] Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final planJson = decoded["plan"];
        List<PlanStepModel> steps = [];

        if (planJson is Map && planJson["steps"] is List) {
          for (final s in (planJson["steps"] as List)) {
            if (s is Map) {
              steps.add(PlanStepModel(
                title: s["title"]?.toString() ?? "",
                description: s["description"]?.toString() ?? "",
              ));
            }
          }
        }

        return MakeAPlanResult(
          success: true,
          message: decoded["message"] ?? "Plan generated successfully",
          steps: steps,
        );
      } else {
        String errorMessage = decoded["message"] ??
            decoded["error"] ??
            "Failed to generate plan. Please try again.";
        return MakeAPlanResult(success: false, message: errorMessage);
      }
    } on http.ClientException catch (e) {
      print("🔴 [ChatService] Network Error: $e");
      return MakeAPlanResult(
        success: false,
        message: "Network error. Please check your internet connection.",
      );
    } on FormatException catch (e) {
      print("🔴 [ChatService] Parsing Error: $e");
      return MakeAPlanResult(
          success: false, message: "Invalid response from server.");
    } catch (e) {
      print("🔴 [ChatService] Unexpected Error: $e");
      return MakeAPlanResult(
          success: false,
          message: "Unexpected error occurred. Please try again.");
    }
  }
}

// -------------------- Results & Models --------------------

class ChatSendResult {
  final bool success;
  final String message;
  final int? conversationId;
  final String? reply;

  ChatSendResult({
    required this.success,
    required this.message,
    this.conversationId,
    this.reply,
  });
}

class ConversationResult {
  final bool success;
  final String message;
  final ConversationModel? conversation;
  final List<ChatMessageModel> messages;

  ConversationResult({
    required this.success,
    required this.message,
    this.conversation,
    this.messages = const [],
  });
}

class ConversationModel {
  final int id;
  final String title;
  final String category;
  final bool isFlagged;
  final String createdAt;

  ConversationModel({
    required this.id,
    required this.title,
    required this.category,
    required this.isFlagged,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      category: json["category"] ?? "",
      isFlagged: json["is_flagged"] ?? false,
      createdAt: json["created_at"] ?? "",
    );
  }
}

class ChatMessageModel {
  final int id;
  final String sender; // "user" or "ai"
  final String message;
  final String time;
  final String date;

  ChatMessageModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.date,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"] ?? 0,
      sender: json["sender"] ?? "ai",
      message: json["message"] ?? "",
      time: json["time"] ?? "",
      date: json["date"] ?? "",
    );
  }
}

class HelpMeSayItResult {
  final bool success;
  final String message;
  final String? draft;

  HelpMeSayItResult({
    required this.success,
    required this.message,
    this.draft,
  });
}

class DecideOptionModel {
  final String title;
  final String subtitle;
  final List<String> pros;
  final List<String> cons;

  DecideOptionModel({
    required this.title,
    required this.subtitle,
    required this.pros,
    required this.cons,
  });
}

class HelpMeDecideResult {
  final bool success;
  final String message;
  final String summary;
  final List<DecideOptionModel> options;

  HelpMeDecideResult({
    required this.success,
    required this.message,
    this.summary = "",
    this.options = const [],
  });
}

class PlanStepModel {
  final String title;
  final String description;

  PlanStepModel({
    required this.title,
    required this.description,
  });
}

class MakeAPlanResult {
  final bool success;
  final String message;
  final List<PlanStepModel> steps;

  MakeAPlanResult({
    required this.success,
    required this.message,
    this.steps = const [],
  });
}