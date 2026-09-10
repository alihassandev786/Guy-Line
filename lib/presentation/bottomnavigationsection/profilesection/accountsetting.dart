import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';

import '../../../data/controllers/accountsettingcontroller.dart';
import '../../Widgets/CustomHeader.dart';

class Accountsetting extends StatefulWidget {
  const Accountsetting({super.key});

  @override
  State<Accountsetting> createState() => _AccountsettingState();
}

class _AccountsettingState extends State<Accountsetting> {
  final controller = Get.isRegistered<AccountSettingsController>()
      ? Get.find<AccountSettingsController>()
      : Get.put(AccountSettingsController());

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ---------------------------------------------------------
            /// 1. HEADER — back button + title
            /// ---------------------------------------------------------
            Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: CustomHeader(title: "Account Setting",titleSize: AppSize.height*0.026,showBackButton: true,),
            ),

            SizedBox(height: AppSize.heightPercent(0.04)),

            /// ---------------------------------------------------------
            /// 2. SETTINGS LIST
            /// ---------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_rounded,
                    title: "Edit Profile",
                    onTap: controller.goToEditProfile,
                  ),
                  SizedBox(height: AppSize.heightPercent(0.01)),
                  _SettingsTile(
                    icon: Icons.lock_rounded,
                    title: "Change Password",
                    onTap: controller.goToChangePassword,
                  ),
                  SizedBox(height: AppSize.heightPercent(0.01)),
                  _SettingsTile(
                    icon: Icons.description_rounded,
                    title: "Terms & Conditions",
                    onTap: controller.goToTermsAndConditions,
                  ),
                  SizedBox(height: AppSize.heightPercent(0.01)),
                  _SettingsTile(
                    icon: Icons.privacy_tip_rounded,
                    title: "Privacy Policy",
                    onTap: controller.goToPrivacyPolicy,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// REUSABLE SETTINGS TILE — glass-style card, icon left, chevron right
/// -----------------------------------------------------------------------
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: AppSize.heightPercent(0.08),
        padding: EdgeInsets.symmetric(horizontal: AppSize.widthPercent(0.045)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: AppSize.widthPercent(0.1),
              width: AppSize.widthPercent(0.1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary1.withOpacity(0.22),
              ),
              child: Icon(
                icon,
                color: AppColors.primary1,
                size: AppSize.widthPercent(0.05),
              ),
            ),
            SizedBox(width: AppSize.widthPercent(0.04)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pm",
                  fontSize: AppSize.widthPercent(0.042),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary1,
              size: AppSize.widthPercent(0.06),
            ),
          ],
        ),
      ),
    );
  }
}