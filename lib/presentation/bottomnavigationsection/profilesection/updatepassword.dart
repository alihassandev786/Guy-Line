import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/Widgets/Textfield.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import '../../../data/controllers/updatepasswordcontroller.dart';

class Updatepassword extends StatefulWidget {
  const Updatepassword({super.key});

  @override
  State<Updatepassword> createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> {
  final controller = Get.isRegistered<UpdatePasswordController>()
      ? Get.find<UpdatePasswordController>()
      : Get.put(UpdatePasswordController());

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
                SizedBox(height: AppSize.heightPercent(0.025)),

                /// 1. TOP BACK BUTTON
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackButton(),
                ),

                SizedBox(height: AppSize.heightPercent(0.05)),

                /// 2. GLOWING LOCK ICON
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
                          color: AppColors.primary1.withOpacity(0.25),
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

                SizedBox(height: AppSize.heightPercent(0.05)),

                /// 3. TITLE & SUBTITLE
                Text(
                  "Password!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1.withOpacity(0.8),
                    fontFamily: "pr",
                    fontSize: AppSize.widthPercent(0.035),
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.005)),
                Text(
                  "Change Password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pb",
                    fontSize: AppSize.widthPercent(0.06),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 4. CURRENT PASSWORD FIELD
                Obx(
                      () => CustomTextField(
                    controller: controller.currentPasswordController,
                    hintText: "Current Password",
                    obscureText: !controller.isCurrentPasswordVisible.value,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: GestureDetector(
                      onTap: controller.toggleCurrentPasswordVisibility,
                      child: Icon(
                        controller.isCurrentPasswordVisible.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.primary1,
                        size: AppSize.widthPercent(0.05),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.012)),

                /// 5. NEW PASSWORD FIELD
                Obx(
                      () => CustomTextField(
                    controller: controller.newPasswordController,
                    hintText: "New Password",
                    obscureText: !controller.isNewPasswordVisible.value,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: GestureDetector(
                      onTap: controller.toggleNewPasswordVisibility,
                      child: Icon(
                        controller.isNewPasswordVisible.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.primary1,
                        size: AppSize.widthPercent(0.05),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.012)),

                /// 6. CONFIRM PASSWORD FIELD
                Obx(
                      () => CustomTextField(
                    controller: controller.confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: GestureDetector(
                      onTap: controller.toggleConfirmPasswordVisibility,
                      child: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.primary1,
                        size: AppSize.widthPercent(0.05),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 7. ACTION BUTTON
                Obx(
                      () => CustomButton(
                    title: controller.isLoading.value ? "Updating..." : "Updated",
                    onTap: controller.isLoading.value
                        ? null
                        : controller.updatePassword,   // ← yeh important hai
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