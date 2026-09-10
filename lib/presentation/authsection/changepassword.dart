import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import '../../data/controllers/changepasswordcontroller.dart';
import '../Widgets/Button.dart';
import '../Widgets/Textfield.dart';
import '../Widgets/appbackground.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  // ★ Safe way — binding miss ho bhi to controller ban jayega
  final controller = Get.put(ChangePasswordController());

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
                  child: CustomBackButton(),
                ),

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
                  "Password!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1.withOpacity(0.8),
                    fontFamily: "pr",
                    fontSize: AppSize.widthPercent(0.032),
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.005)),
                Text(
                  "Create Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pb",
                    fontSize: AppSize.widthPercent(0.06),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.07)),

                /// 4. NEW PASSWORD FIELD
                CustomTextField(
                  controller: controller.newPasswordController,
                  hintText: "New Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),

                SizedBox(height: AppSize.heightPercent(0.01)),

                /// 5. CONFIRM PASSWORD FIELD
                CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),

                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 6. CREATE PASSWORD BUTTON
                Obx(
                      () => CustomButton(
                    title: controller.isLoading.value ? "Creating..." : "Create Password",
                    onTap: controller.isLoading.value ? () {} : controller.createPassword,
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