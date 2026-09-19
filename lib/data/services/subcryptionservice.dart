import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guyline/core/network/apiendpoints.dart';
import 'sessionmanager.dart';

class SubscriptionService {
  /// GET /api/subscription-plan
  Future<SubscriptionPlanResult> getPlans() async {
    final uri = Uri.parse(ApiEndpoints.subscriptionPlan);

    print("🔵 [SubscriptionService] GET Plans");
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
        } else if (decoded["plans"] is List) {
          list = decoded["plans"];
        }
        else if (decoded["plan"] is Map) {
          list = [decoded["plan"]];
        }

        final plans = list
            .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
            .toList();

        return SubscriptionPlanResult(
          success: true,
          message: "Plans loaded",
          plans: plans,
        );
      } else {
        return SubscriptionPlanResult(
          success: false,
          message: decoded["message"] ?? "Failed to load plans",
        );
      }
    } catch (e) {
      print("❌ [SubscriptionService] $e");
      return SubscriptionPlanResult(
        success: false,
        message: "Something went wrong",
      );
    }
  }

  /// POST /api/subscription/subscribe
  Future<SubscribeResult> subscribe({
    required int planId,
    required String cardNumber,
  }) async {
    final user = SessionManager.instance.getUser();
    if (user == null) {
      return SubscribeResult(success: false, message: "User not logged in");
    }

    final uri = Uri.parse(ApiEndpoints.subscribe);
    final body = {
      "user_id": user.id,
      "plan_id": planId,
      "card_number": cardNumber,
    };

    print("🔵 [SubscriptionService] SUBSCRIBE");
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
          .timeout(const Duration(seconds: 25));

      print("🟢 Status: ${response.statusCode}");
      print("🟢 Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SubscribeResult(
          success: true,
          message: decoded["message"] ?? "Subscribed successfully",
        );
      } else {
        return SubscribeResult(
          success: false,
          message: decoded["message"] ?? "Subscription failed",
        );
      }
    } catch (e) {
      print("❌ [SubscriptionService] $e");
      return SubscribeResult(success: false, message: "Something went wrong");
    }
  }
}

/// ---------------- Models ----------------

class SubscriptionPlan {
  final int id;
  final String name;
  final String price;
  final String period;
  final List<String> features;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    this.features = const [],
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    List<String> feats = [];
    if (json["features"] is List) {
      feats = (json["features"] as List).map((e) => e.toString()).toList();
    }

    // price backend se number (19.99) ya string ("$19.99") dono ho sakta hai
    final rawPrice = json["price"] ?? json["amount"];
    String formattedPrice;
    if (rawPrice == null) {
      formattedPrice = "\$19.99";
    } else if (rawPrice is num) {
      formattedPrice = "\$${rawPrice.toStringAsFixed(2)}";
    } else {
      formattedPrice = rawPrice.toString();
    }

    // period ab "billing_cycle" se bhi aa sakta hai
    final rawPeriod =
        json["period"] ?? json["interval"] ?? json["billing_cycle"];
    final formattedPeriod = rawPeriod != null ? "/$rawPeriod" : "/month";

    return SubscriptionPlan(
      id: json["id"] ?? 0,
      name: json["name"] ?? json["title"] ?? "Premium",
      price: formattedPrice,
      period: formattedPeriod,
      features: feats,
    );
  }
}

class SubscriptionPlanResult {
  final bool success;
  final String message;
  final List<SubscriptionPlan> plans;

  SubscriptionPlanResult({
    required this.success,
    required this.message,
    this.plans = const [],
  });
}

class SubscribeResult {
  final bool success;
  final String message;

  SubscribeResult({required this.success, required this.message});
}