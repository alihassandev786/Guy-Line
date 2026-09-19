import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/Widgets/snackbar.dart';
import '../services/notificationservice.dart';
import '../services/sessionmanager.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();

  final isLoading = false.obs;
  final errorMessage = "".obs;
  final notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    if (SessionManager.instance.getUser() == null) {
      errorMessage.value = "Please login first";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    final result = await _service.getNotifications();

    isLoading.value = false;

    if (result.success) {
      notifications.assignAll(result.notifications);
      print("✅ [NotificationController] Loaded ${notifications.length}");
    } else {
      errorMessage.value = result.message;
    }
  }

  Future<void> onNotificationTap(AppNotification item) async {
    if (!item.isRead) {
      final ok = await _service.markAsRead(item.id);
      if (ok) {
        final index = notifications.indexWhere((e) => e.id == item.id);
        if (index != -1) {
          notifications[index] = item.copyWith(isRead: true);
          notifications.refresh();
        }
      }
    }
    // Yahan detail / conversation open kar sakte ho agar type ke hisaab se chahiye
  }

  Future<void> markAllRead() async {
    final ok = await _service.markAllAsRead();
    if (ok) {
      notifications.value =
          notifications.map((e) => e.copyWith(isRead: true)).toList();
      SnackbarService.success("All notification marked as read");

    }
  }

  Future<void> refresh() async => loadNotifications();
}