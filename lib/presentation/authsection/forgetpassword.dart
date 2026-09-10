import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import '../../core/routes/approutes.dart';
import '../../data/controllers/forgetpasswordcontroller.dart';
import '../Widgets/AppNavigator.dart';
import '../Widgets/Button.dart';
import '../Widgets/Textfield.dart';
import '../Widgets/appbackground.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final controller = Get.find<ForgetPasswordController>();



  @override
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
                SizedBox(height: AppSize.heightPercent(0.015)),

                /// 1. TOP BACK BUTTON
                Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton()),

                SizedBox(height: AppSize.heightPercent(0.08)),

                /// 2. LOCK IMAGE / ICON CONTAINER
                Center(
                  child: Container(
                    height: AppSize.widthPercent(0.35),
                    width: AppSize.widthPercent(0.35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary1.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.primary1.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary1.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: AppSize.widthPercent(0.16),
                      color: AppColors.primary1,
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.09)),

                /// 3. TITLE & SUBTITLE TEXT
                Text(
                  "Dont worry!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1.withOpacity(0.8),
                    fontFamily: "pr",
                    fontSize: AppSize.widthPercent(0.032),
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.005)),
                Text(
                  "Forgot Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pb",
                    fontSize: AppSize.widthPercent(0.06),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.07)),

                /// 4. EMAIL INPUT FIELD
                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 5. SEND CODE BUTTON
                Obx(
                      () => CustomButton(
                    title: controller.isLoading.value ? "Sending..." : "Send Code",
                    onTap: controller.isLoading.value ? () {} : controller.sendCode,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.03)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}