import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/data/controllers/notificationcontroller.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

import '../../../data/services/notificationservice.dart';

class Notification extends StatefulWidget {
  const Notification({super.key});

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final hp = AppSize.widthPercent(0.05);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hp,
                vertical: AppSize.heightPercent(0.015),
              ),
              child: Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(width: AppSize.widthPercent(0.04)),
                  Expanded(
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        color: AppColors.textcolor1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.055),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Mark all read
                  GestureDetector(
                    onTap: controller.markAllRead,
                    child: Text(
                      "Mark all",
                      style: TextStyle(
                        color: AppColors.primary1,
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.032),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary1),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: AppColors.textcolor2),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: controller.refresh,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No notifications yet",
                      style: TextStyle(
                        color: AppColors.textcolor2,
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.04),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary1,
                  onRefresh: controller.refresh,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: hp,
                      vertical: AppSize.heightPercent(0.01),
                    ),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSize.heightPercent(0.015)),
                    itemBuilder: (context, index) {
                      final item = controller.notifications[index];
                      return _NotificationCard(
                        item: item,
                        onTap: () => controller.onNotificationTap(item),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  IconData get _icon {
    switch (item.type) {
      case "session":
        return Icons.shield_outlined;
      case "conversation":
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.widthPercent(0.04),
          vertical: AppSize.heightPercent(0.018),
        ),
        decoration: BoxDecoration(
          color: item.isRead
              ? AppColors.primary2.withOpacity(0.1)
              : AppColors.primary2.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppSize.widthPercent(0.11),
              width: AppSize.widthPercent(0.11),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary1.withOpacity(0.18),
              ),
              child: Icon(
                _icon,
                color: AppColors.primary1,
                size: AppSize.widthPercent(0.05),
              ),
            ),
            SizedBox(width: AppSize.widthPercent(0.035)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: AppColors.textcolor1,
                      fontFamily: "pb",
                      fontSize: AppSize.widthPercent(0.038),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSize.heightPercent(0.005)),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: AppColors.textcolor2,
                      fontFamily: "pr",
                      fontSize: AppSize.widthPercent(0.032),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: AppSize.heightPercent(0.008)),
                  Text(
                    item.time,
                    style: TextStyle(
                      color: AppColors.textcolor2.withOpacity(0.7),
                      fontFamily: "pr",
                      fontSize: AppSize.widthPercent(0.028),
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}