import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import '../../../data/controllers/profilecontroller.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);
    final double bannerHeight = AppSize.heightPercent(0.24);
    final double avatarSize = AppSize.widthPercent(0.26);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------------------------------------------------
              /// 1. SIMPLE ROUNDED BANNER WITH BOTTOM-LEFT FLOATING AVATAR
              /// ---------------------------------------------------------
              _ProfileHeader(
                controller: controller,
                bannerHeight: bannerHeight,
                avatarSize: avatarSize,
                horizontalPadding: horizontalPadding,
              ),

              SizedBox(height: avatarSize * 0.35),

              /// ---------------------------------------------------------
              /// 2. NAME, EMAIL & EDIT PROFILE BUTTON
              /// ---------------------------------------------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.name.value,
                        style: TextStyle(
                          color: AppColors.textcolor1,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.055),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: AppSize.heightPercent(0.005)),
                      Text(
                        controller.email.value,
                        style: TextStyle(
                          color: AppColors.textcolor1.withOpacity(0.55),
                          fontFamily: "pr",
                          fontSize: AppSize.widthPercent(0.033),
                        ),
                      ),
                      SizedBox(height: AppSize.heightPercent(0.018)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSize.heightPercent(0.025)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    _ProfileMenuTile(
                      icon: Icons.person_rounded,
                      title: "Account Settings",
                      onTap: controller.goToAccountSettings,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(
                      icon: Icons.notifications_rounded,
                      title: "Notifications",
                      onTap: controller.goToNotifications,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(
                      icon: Icons.shield_rounded,
                      title: "Privacy & Security",
                      onTap: controller.goToPrivacyAndSecurity,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(
                      icon: Icons.laptop_chromebook_rounded,
                      title: "Subscription",
                      onTap: controller.goToSubscription,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(
                      icon: Icons.info_rounded,
                      title: "About Guy Line",
                      onTap: controller.goToAbout,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(
                      icon: Icons.help_rounded,
                      title: "Support Center",
                      onTap: controller.goToSupportCenter,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(
                      icon: Icons.star_rounded,
                      title: "Rate App",
                      onTap: controller.rateApp,
                    ),

                    SizedBox(height: AppSize.heightPercent(0.03)),

                    /// -----------------------------------------------------
                    /// 5. LOGOUT BUTTON (TRIGGERS CUSTOM ALERT DIALOG)
                    /// -----------------------------------------------------
                    GestureDetector(
                      onTap: () => controller.logout(context),
                      child: Container(
                        width: double.infinity,
                        height: AppSize.heightPercent(0.065),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD32F2F), Color(0xFF8E0000)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB30000).withOpacity(0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: AppSize.widthPercent(0.02)),
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pb",
                                fontSize: AppSize.widthPercent(0.042),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.03)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// SIMPLE BANNER (rounded bottom corners) + BOTTOM-LEFT FLOATING AVATAR
/// -----------------------------------------------------------------------
class _ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  final double bannerHeight;
  final double avatarSize;
  final double horizontalPadding;

  const _ProfileHeader({
    required this.controller,
    required this.bannerHeight,
    required this.avatarSize,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerHeight + (avatarSize * 0.5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Simple rounded banner box
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSize.widthPercent(0.09)),
              bottomRight: Radius.circular(AppSize.widthPercent(0.09)),
            ),
            child: SizedBox(
              height: bannerHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Obx(() {
                    final bannerPath = controller.selectedBannerPath.value;
                    if (bannerPath != null && bannerPath.isNotEmpty) {
                      return Image.file(
                        File(bannerPath),
                        fit: BoxFit.cover,
                      );
                    }
                    return Image.asset(
                      controller.defaultBannerImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary1.withOpacity(0.55),
                              AppColors.primary2.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.black.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.6],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Floating avatar — bottom-left of the banner, with left padding
          Positioned(
            top: bannerHeight - (avatarSize * 0.5),
            left:AppSize.height*0.04,
            child: Container(
              height: avatarSize,
              width: avatarSize,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary2,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Obx(() {
                  final avatarPath = controller.selectedAvatarPath.value;
                  if (avatarPath != null && avatarPath.isNotEmpty) {
                    return Image.file(
                      File(avatarPath),
                      fit: BoxFit.cover,
                    );
                  }
                  return Image.asset(
                    controller.defaultAvatarImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primary1.withOpacity(0.3),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary1,
                        size: avatarSize * 0.5,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// REUSABLE MENU TILE
/// -----------------------------------------------------------------------
class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuTile({
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
        height: AppSize.heightPercent(0.074),
        padding: EdgeInsets.symmetric(horizontal: AppSize.widthPercent(0.04)),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        child: Row(
          children: [
            Container(
              height: AppSize.widthPercent(0.1),
              width: AppSize.widthPercent(0.1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary1.withOpacity(0.18),
              ),
              child: Icon(
                icon,
                color: AppColors.primary1,
                size: AppSize.widthPercent(0.05),
              ),
            ),
            SizedBox(width: AppSize.widthPercent(0.035)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pm",
                  fontSize: AppSize.widthPercent(0.038),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary1,
              size: AppSize.widthPercent(0.04),
            ),
          ],
        ),
      ),
    );
  }
}