import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  final double? height;
  final double? textSize;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  final Widget? leftWidget;
  final EdgeInsets? leftPadding;
  final Alignment? leftAlignment;

  final Widget? rightWidget;
  final EdgeInsets? rightPadding;
  final Alignment? rightAlignment;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.textSize,
    this.rightWidget,
    this.rightPadding,
    this.rightAlignment,
    this.leftWidget,
    this.leftPadding,
    this.leftAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final size = Get.size;

    // Theme-Aware Colors
    // Primary color ko theme se pick kar rahe hain (0xff94C973)
    final bgColor = backgroundColor ?? AppColors.primary1.withOpacity(0.9);
    final brColor = borderColor ?? Colors.transparent;

    // Text color default white rahega agar background primaryGreen hai
    final txtColor = textColor ?? Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: brColor),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (leftWidget != null)
              Positioned(
                left: leftPadding?.left ?? size.width * 0.02,
                top: leftPadding?.top,
                bottom: leftPadding?.bottom,
                child: Align(
                  alignment: leftAlignment ?? Alignment.centerLeft,
                  child: Padding(
                    padding: leftPadding ?? EdgeInsets.zero,
                    child: leftWidget!,
                  ),
                ),
              ),

            /// TITLE (CENTER)
            Text(
              title,
              style: TextStyle(
                color: txtColor,
                fontSize: textSize ?? size.width * 0.038,
                fontFamily: "ps",
                fontWeight: FontWeight.w600,
              ),
            ),

            /// RIGHT WIDGET
            if (rightWidget != null)
              Positioned(
                right: rightPadding?.right ?? size.width * 0.02,
                top: rightPadding?.top,
                bottom: rightPadding?.bottom,
                child: Align(
                  alignment: rightAlignment ?? Alignment.centerRight,
                  child: Padding(
                    padding: rightPadding ?? EdgeInsets.zero,
                    child: rightWidget!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}