import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import '../../../data/controllers/profilecontroller.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);
    final double bannerHeight = AppSize.heightPercent(0.22);
    final double avatarSize = AppSize.widthPercent(0.28);

    return WillPopScope(
      onWillPop: () async {
        controller.discardUnsavedChanges();
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: AppBackground(
          padding: EdgeInsets.zero,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _EditProfileHeader(
                      controller: controller,
                      bannerHeight: bannerHeight,
                      avatarSize: avatarSize,
                      horizontalPadding: horizontalPadding,
                    ),
                    SizedBox(height: AppSize.heightPercent(0.02)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Text(
                        "Change Profile Picture",
                        style: TextStyle(
                          fontSize: AppSize.height * 0.015,
                          fontWeight: FontWeight.bold,
                          fontFamily: "pr",
                          color: AppColors.textcolor1,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSize.heightPercent(0.035)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          _EditInputField(
                            label: "Username",
                            controller: controller.nameController,
                            icon: Icons.edit_rounded,
                          ),
                          SizedBox(height: AppSize.heightPercent(0.012)),
                          _EditInputField(
                            label: "Email Address",
                            controller: controller.emailController,
                            icon: Icons.lock_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                          ),
                          SizedBox(height: AppSize.heightPercent(0.08)),
                          Obx(
                                () => CustomButton(
                              title: controller.isLoading.value ? "Saving..." : "Save Changes",
                              onTap: controller.isLoading.value ? null : controller.saveProfileChanges,
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
          ),
        ),
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  final ProfileController controller;
  final double bannerHeight;
  final double avatarSize;
  final double horizontalPadding;

  const _EditProfileHeader({
    required this.controller,
    required this.bannerHeight,
    required this.avatarSize,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final double headerHeight = (bannerHeight - (avatarSize * 0.15)) + avatarSize + 20;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: bannerHeight + (avatarSize * 0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSize.widthPercent(0.09)),
                bottomRight: Radius.circular(AppSize.widthPercent(0.09)),
              ),
              child: Obx(() {
                final version = controller.avatarVersion.value;
                return KeyedSubtree(
                  key: ValueKey('edit_banner_$version'),
                  child: _buildBanner(),
                );
              }),
            ),
          ),

          // Avatar + Camera
          Positioned(
            top: bannerHeight - (avatarSize * 0.15),
            left: horizontalPadding,
            child: SizedBox(
              height: avatarSize + 20,
              width: avatarSize + 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: controller.changeProfilePicture,
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
                            key: ValueKey('edit_avatar_$version'),
                            child: _buildAvatarImage(),
                          );
                        }),
                      ),
                    ),
                  ),

                  // Camera button
                  Positioned(
                    bottom: AppSize.height*0.03,
                    right: AppSize.height*0.02,
                    child: Material(
                      color: AppColors.primary1,
                      shape: const CircleBorder(),
                      elevation: 4,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: controller.changeProfilePicture,
                        child: Container(
                          width: AppSize.widthPercent(0.09),
                          height: AppSize.widthPercent(0.09),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: AppSize.widthPercent(0.04),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
            errorBuilder: (_, __, ___) => _defaultBanner(),
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
        errorBuilder: (_, __, ___) => _defaultAvatar(),
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

class _EditInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final bool readOnly;

  const _EditInputField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.widthPercent(0.045),
        vertical: AppSize.heightPercent(0.008),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        enableInteractiveSelection: !readOnly,
        style: TextStyle(
          color: AppColors.textcolor1,
          fontFamily: "pm",
          fontSize: AppSize.widthPercent(0.038),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.textcolor1.withOpacity(0.5),
            fontFamily: "pr",
            fontSize: AppSize.widthPercent(0.033),
          ),
          suffixIcon: Icon(icon, color: AppColors.primary1, size: AppSize.widthPercent(0.048)),
        ),
      ),
    );
  }
}