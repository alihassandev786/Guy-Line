import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final price = "\$19.99".obs;
  final period = "/month".obs;

  final features = <String>[
    "Unlimited private conversations",
    "Advanced emotional intelligence models",
    "Absolute data privacy guarantee",
  ].obs;

  void subscribeNow() {
    Get.snackbar(
      "Subscription",
      "Processing your payment request...",
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Integrate in-app purchase (IAP) / Payment Gateway logic here
  }
}