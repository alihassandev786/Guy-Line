import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ProfileController controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);
    final double bannerHeight = AppSize.heightPercent(0.22);
    final double avatarSize = AppSize.widthPercent(0.28);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: AppBackground(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(
                controller: controller,
                bannerHeight: bannerHeight,
                avatarSize: avatarSize,
                horizontalPadding: horizontalPadding,
              ),
              SizedBox(height: avatarSize * 0.55),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.name.value.isEmpty ? "User" : controller.name.value,
                        style: TextStyle(
                          color: AppColors.textcolor1,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.055),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.email.value,
                        style: TextStyle(
                          color: AppColors.textcolor1.withOpacity(0.55),
                          fontFamily: "pr",
                          fontSize: AppSize.widthPercent(0.033),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.heightPercent(0.022)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    _ProfileMenuTile(icon: Icons.person_rounded, title: "Account Settings", onTap: controller.goToAccountSettings),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(icon: Icons.notifications_rounded, title: "Notifications", onTap: controller.goToNotifications),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(icon: Icons.shield_rounded, title: "Interaction Preference", onTap: controller.goTointrectionprefrence),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(icon: Icons.laptop_chromebook_rounded, title: "Subscription", onTap: controller.goToSubscription),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(icon: Icons.info_rounded, title: "About Guy Line", onTap: controller.goToAbout),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(icon: Icons.help_rounded, title: "Support Center", onTap: controller.goToSupportCenter),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _ProfileMenuTile(icon: Icons.star_rounded, title: "Rate App", onTap: controller.rateApp),
                    SizedBox(height: AppSize.heightPercent(0.03)),
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
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                            SizedBox(width: AppSize.widthPercent(0.02)),
                            Text("Logout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "pb",
                                  fontSize: AppSize.widthPercent(0.042),
                                  fontWeight: FontWeight.w600,
                                )),
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
          // ========== BANNER (ab image bhi dikhayega) ==========
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSize.widthPercent(0.09)),
              bottomRight: Radius.circular(AppSize.widthPercent(0.09)),
            ),
            child: SizedBox(
              height: bannerHeight + (avatarSize * 0.5),
              width: double.infinity,
              child: Obx(() {
                final version = controller.avatarVersion.value;
                return KeyedSubtree(
                  key: ValueKey('banner_$version'),
                  child: _buildBanner(),
                );
              }),
            ),
          ),

          // ========== FLOATING AVATAR ==========
          Positioned(
            top: bannerHeight - (avatarSize * 0.15),
            left: horizontalPadding,
            child: Container(
              height: avatarSize,
              width: avatarSize,
              padding: const EdgeInsets.all(3.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1B1B1B),
                border: Border.all(color: AppColors.primary1.withOpacity(0.5), width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Obx(() {
                  final version = controller.avatarVersion.value;
                  return KeyedSubtree(
                    key: ValueKey('avatar_$version'),
                    child: _buildAvatarImage(),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBanner() {
    final provider = controller.avatarImageProvider;
    if (provider != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: provider,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              print("🔴 Banner image failed to load");
              return _defaultBanner();
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return _defaultBanner();
  }

  Widget _defaultBanner() {
    return Container(
      color: AppColors.primary2.withOpacity(0.12),
      child: Center(
        child: Icon(
          Icons.person_outline_rounded,
          size: AppSize.widthPercent(0.28),
          color: AppColors.primary1.withOpacity(0.35),
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    final provider = controller.avatarImageProvider;
    if (provider != null) {
      return Image(
        image: provider,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          print("🔴 Avatar image failed to load");
          return _defaultAvatar();
        },
      );
    }
    return _defaultAvatar();
  }
  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFF1B1B1B),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: avatarSize * 0.5,
        color: AppColors.primary1.withOpacity(0.85),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: AppSize.heightPercent(0.074),
        padding: EdgeInsets.symmetric(horizontal: AppSize.widthPercent(0.04)),
        decoration: BoxDecoration(
          color: AppColors.primary2.withOpacity(0.1),
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
              child: Icon(icon, color: AppColors.primary1, size: AppSize.widthPercent(0.05)),
            ),
            SizedBox(width: AppSize.widthPercent(0.035)),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pm",
                  fontSize: AppSize.widthPercent(0.038),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary1, size: AppSize.widthPercent(0.04)),
          ],
        ),
      ),
    );
  }
}