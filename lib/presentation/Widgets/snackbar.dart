import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Success/Error/Info messages dikhane ke liye - GetX ka Get.rawSnackbar use karta hai
/// (poora custom control milta hai shadow, spacing, aur multi-line text ke liye).
class SnackbarService {
  SnackbarService._();

  static void success(String message) {
    _show(
      title: 'Success',
      message: message,
      backgroundColor: const Color(0xFF1B5E3A),
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF4ADE80),
    );
  }

  static void error(String message) {
    _show(
      title: 'Error',
      message: message,
      backgroundColor: const Color(0xFF5A1F24),
      icon: Icons.error_rounded,
      iconColor: const Color(0xFFF87171),
    );
  }

  static void info(String message) {
    _show(
      title: 'Info',
      message: message,
      backgroundColor: const Color(0xFF1E2A3A),
      icon: Icons.info_rounded,
      iconColor: const Color(0xFF60A5FA),
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final BuildContext? context = Get.overlayContext ?? Get.context;
    final double w = context != null ? MediaQuery.of(context).size.width : 375.0;
    final double h = context != null ? MediaQuery.of(context).size.height : 812.0;

    Get.rawSnackbar(
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(w * 0.016),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: w * 0.048),
          ),
          SizedBox(width: w * 0.026),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.036,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                height: 1.3, // 👈 line spacing thodi acchi rakhi
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(horizontal: w * 0.037, vertical: h * 0.012),
      padding: EdgeInsets.symmetric(horizontal: w * 0.037, vertical: h * 0.015),
      borderRadius: w * 0.037,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      snackStyle: SnackStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: w * 0.042,
          spreadRadius: 1,
          offset: Offset(0, h * 0.007),
        ),
      ],
    );
  }
}
