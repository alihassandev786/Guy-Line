import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

import '../../core/routes/approutes.dart';
import '../../data/controllers/logincontroller.dart';
import '../Widgets/Button.dart';
import '../Widgets/Textfield.dart';
import '../Widgets/appbackground.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  late final LoginController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.06);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: SingleChildScrollView(
          
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSize.heightPercent(0.03)),

                /// 1. LOGO SECTION
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: AppSize.heightPercent(0.09),
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.07)),

                /// 2. WELCOME & TITLE TEXT
                Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1.withOpacity(0.8),
                    fontFamily: "pr",
                    fontSize: AppSize.widthPercent(0.03),
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.005)),
                Text(
                  "Please, Log In.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pb",
                    fontSize: AppSize.widthPercent(0.06),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.03)),

                /// 3. INPUT FORM FIELDS
                CustomTextField(
                  controller: controller.usernameController,
                  hintText: "Email",
                  focusedBorderColor: AppColors.primary1,
                ),
                SizedBox(height: AppSize.heightPercent(0.01)),

                Obx(
                      () => CustomTextField(
                    controller: controller.passwordController,
                    hintText: "Password",
                    obscureText: controller.isObscurePassword.value,
                    focusedBorderColor: AppColors.primary1,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isObscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.primary1,
                        size: AppSize.widthPercent(0.055),
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.02)),

                /// 4. REMEMBER ME & FORGOT PASSWORD ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Remember Me Checkbox
                    GestureDetector(
                      onTap: controller.toggleRememberMe,
                      child: Row(
                        children: [
                          Obx(
                                () => Container(
                              height: AppSize.widthPercent(0.055),
                              width: AppSize.widthPercent(0.055),
                              decoration: BoxDecoration(
                                color: controller.rememberMe.value
                                    ? AppColors.primary1
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary1,
                                  width: 1.5,
                                ),
                              ),
                              child: controller.rememberMe.value
                                  ? Icon(
                                Icons.check,
                                size: AppSize.widthPercent(0.04),
                                color: Colors.black,
                              )
                                  : null,
                            ),
                          ),
                          SizedBox(width: AppSize.widthPercent(0.025)),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              color: AppColors.textcolor1,
                              fontFamily: "pr",
                              fontSize: AppSize.widthPercent(0.035),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushRight(AppRoutes.forget);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontFamily: "pm",
                          fontSize: AppSize.widthPercent(0.035),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.heightPercent(0.06)),

                Obx(
                      () => CustomButton(
                    title: controller.isLoading.value ? "Please wait..." : "Log In",
                    onTap: controller.isLoading.value ? null : controller.login,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 6. DIVIDER WITH TEXT
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.widthPercent(0.03),
                      ),
                      child: Text(
                        "Continue with",
                        style: TextStyle(
                          color: AppColors.textcolor1.withOpacity(0.7),
                          fontFamily: "pr",
                          fontSize: AppSize.widthPercent(0.032),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.heightPercent(0.035)),

                /// 7. SOCIAL MEDIA BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      color: const Color(0xFF1877F2),
                      iconData: Icons.facebook,
                      iconColor: Colors.white,
                      onTap: () {},
                    ),
                    SizedBox(width: AppSize.widthPercent(0.04)),
                    _buildSocialButton(
                      color: const Color(0xFF1DA1F2),
                      iconData: Icons.flutter_dash,
                      iconColor: Colors.white,
                      onTap: () {},
                    ),
                    SizedBox(width: AppSize.widthPercent(0.04)),
                    _buildSocialButton(
                      color: Colors.white,
                      isGoogle: true,
                      onTap: () {},
                    ),
                    SizedBox(width: AppSize.widthPercent(0.04)),
                    _buildSocialButton(
                      color: const Color(0xFF161616),
                      iconData: Icons.apple,
                      iconColor: Colors.white,
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: AppSize.heightPercent(0.05)),

                /// 8. SIGN UP NAVIGATION LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t have an account? ",
                      style: TextStyle(
                        color: AppColors.textcolor1.withOpacity(0.8),
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.036),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(AppRoutes.signup);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.036),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.heightPercent(0.03)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper Widget for Social Media Buttons
  Widget _buildSocialButton({
    required Color color,
    IconData? iconData,
    Color iconColor = Colors.white,
    bool isGoogle = false,
    VoidCallback? onTap,
  }) {
    final double buttonSize = AppSize.widthPercent(0.12);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isGoogle
              ? CustomPaint(
            size: Size(buttonSize * 0.45, buttonSize * 0.45),
            painter: _GoogleLogoPainter(),
          )
              : Icon(
            iconData,
            color: iconColor,
            size: buttonSize * 0.55,
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------
/// EXACT MULTI-COLOR GOOGLE LOGO PAINTER
/// --------------------------------------------------------------------------
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final double strokeWidth = size.width * 0.28;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Red arc
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -0.6, 2.2, false, paint);

    // Yellow arc
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 1.6, 1.2, false, paint);

    // Green arc
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 2.8, 1.5, false, paint);

    // Blue arc & bar
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, 4.3, 1.0, false, paint);

    final Paint fillPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - (strokeWidth * 0.1),
        center.dy - (strokeWidth / 2),
        radius + (strokeWidth * 0.1),
        strokeWidth,
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}