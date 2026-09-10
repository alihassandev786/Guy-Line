import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';

class CustomAlertDialog {
  static void show({
    required BuildContext context,
    String? title,
    String? subtitle,
    IconData icon = Icons.logout,
    String? confirmText,
    String? cancelText,
    Color? iconColor,
    Color? confirmColor,
    Color? cancelColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool navigateToLoginOnConfirm = false,
  }) {
    // App Dynamic Dark Theme Colors
    final effectiveIconColor = iconColor ?? const Color(0xFFD32F2F);
    final effectiveConfirmColor = confirmColor ?? AppColors.primary1;
    final effectiveCancelColor = cancelColor ?? const Color(0xFF252525);

    final resolvedTitle = title ?? 'Logout';
    final resolvedSubtitle =
        subtitle ?? 'Are you sure you want to log out of your account?';
    final resolvedConfirmText = confirmText ?? 'Confirm';
    final resolvedCancelText = cancelText ?? 'Cancel';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        backgroundColor: const Color(0xFF1B1B1B),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: effectiveIconColor.withOpacity(0.15),
                ),
                child: Icon(icon, color: effectiveIconColor, size: 28),
              ),

              const SizedBox(height: 16),

              /// TITLE
              Text(
                resolvedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pb",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              /// SUBTITLE
              Text(
                resolvedSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor1.withOpacity(0.6),
                  fontFamily: "pr",
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              /// BUTTONS
              Row(
                children: [
                  /// CANCEL BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        if (onCancel != null) onCancel();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: effectiveCancelColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            resolvedCancelText,
                            style: TextStyle(
                              color: AppColors.textcolor1.withOpacity(0.8),
                              fontFamily: "pm",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// CONFIRM BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        if (onConfirm != null) onConfirm();
                        if (navigateToLoginOnConfirm) {
                          Get.offAllNamed(AppRoutes.login);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: effectiveConfirmColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: effectiveConfirmColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            resolvedConfirmText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "pb",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}