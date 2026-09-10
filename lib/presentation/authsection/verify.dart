import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../core/routes/approutes.dart';
import '../../data/controllers/verifypasswordcontroller.dart';
import '../Widgets/AppNavigator.dart';
import '../Widgets/Backbutton.dart';
import '../Widgets/Button.dart';
import '../Widgets/appbackground.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final controller = Get.find<VerifyController>();

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
                      Icons.verified_user_rounded,
                      size: AppSize.widthPercent(0.16),
                      color: AppColors.primary1,
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.09)),

                /// 3. TITLE & SUBTITLE TEXT
                Text(
                  "Verification!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1.withOpacity(0.8),
                    fontFamily: "pr",
                    fontSize: AppSize.widthPercent(0.032),
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.005)),
                Text(
                  "Verify Email?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pb",
                    fontSize: AppSize.widthPercent(0.065),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.05)),

                /// 4. PIN CODE FIELDS
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: controller.otpController,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  // ★★★ YEH LINE SAB SE IMPORTANT HAI ★★★
                  autoDisposeControllers: false,
                  textStyle: TextStyle(
                    fontSize: AppSize.widthPercent(0.05),
                    color: AppColors.textcolor1,
                    fontWeight: FontWeight.bold,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: AppSize.widthPercent(0.14),
                    fieldWidth: AppSize.widthPercent(0.14),
                    activeFillColor: const Color(0xFF1E1E1E),
                    inactiveFillColor: const Color(0xFF1E1E1E),
                    selectedFillColor: const Color(0xFF1E1E1E),
                    activeColor: AppColors.primary1,
                    inactiveColor: AppColors.primary1.withOpacity(0.5),
                    selectedColor: AppColors.primary1,
                    borderWidth: 1.5,
                  ),
                  cursorColor: AppColors.primary1,
                  enableActiveFill: true,
                  onCompleted: (pin) {
                    print("🟡 OTP entered completely: $pin");
                  },
                  onChanged: (value) {},
                ),

                SizedBox(height: AppSize.heightPercent(0.03)),

                /// 5. RESEND CODE TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive any code? ",
                      style: TextStyle(
                        color: AppColors.textcolor1.withOpacity(0.8),
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.032),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.resendCode,
                      child: Text(
                        "Resend Code",
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.032),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 6. CONTINUE BUTTON
                CustomButton(
                  title: "Continue",
                  onTap: () {
                    final isValid = controller.verifyCode();

                    if (isValid) {
                      AppNavigator.pushRight(AppRoutes.changepassword);
                    }
                  },
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