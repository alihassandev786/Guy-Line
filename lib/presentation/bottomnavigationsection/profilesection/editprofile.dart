import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import '../../../data/controllers/profilecontroller.dart';
import 'dart:convert';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------------------------------------------------------
                /// 1. SIMPLE ROUNDED BANNER + BOTTOM-LEFT AVATAR (CAMERA)
                /// ---------------------------------------------------------
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

                /// ---------------------------------------------------------
                /// 2. EDITABLE INPUT FIELDS (USERNAME & EMAIL)
                /// ---------------------------------------------------------
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
                        icon: Icons.edit_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: AppSize.heightPercent(0.08)),
                      Obx(() => CustomButton(
                        title: controller.isLoading.value ? "Saving..." : "Save Changes",
                        onTap: controller.isLoading.value ? null : controller.saveProfileChanges,
                      )),

                      SizedBox(height: AppSize.heightPercent(0.03)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// SIMPLE BANNER (rounded bottom corners) + BOTTOM-LEFT AVATAR WITH CAMERA
/// -----------------------------------------------------------------------
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
    return SizedBox(
      height: bannerHeight + (avatarSize * 0.5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Simple rounded banner box with camera edit button
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

                  /// Banner Camera Edit Button
                  Positioned(
                    top: AppSize.heightPercent(0.015),
                    right: AppSize.widthPercent(0.07),
                    child: GestureDetector(
                      onTap: controller.changeBannerImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Floating avatar — bottom-left of the banner, with left padding
          /// + camera overlay badge to trigger picking a new photo
          Positioned(
            top: bannerHeight - (avatarSize * 0.5),
            left:AppSize.height*0.04,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: controller.changeProfilePicture,
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Obx(() {
                            // 1. Local newly picked
                            final avatarPath = controller.selectedAvatarPath.value;
                            if (avatarPath != null && avatarPath.isNotEmpty) {
                              return Image.file(
                                File(avatarPath),
                                fit: BoxFit.cover,
                              );
                            }

                            // 2. Saved base64 from Session
                            final base64Image = controller.profileImageBase64.value;
                            if (base64Image != null && base64Image.isNotEmpty) {
                              try {
                                final pureBase64 = base64Image.contains(',')
                                    ? base64Image.split(',').last
                                    : base64Image;
                                final bytes = base64Decode(pureBase64);
                                return Image.memory(
                                  bytes,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _defaultAvatar(avatarSize);
                                  },
                                );
                              } catch (e) {
                                return _defaultAvatar(avatarSize);
                              }
                            }

                            // 3. Default
                            return _defaultAvatar(avatarSize);
                          }),

                          // Dark overlay for edit cue
                          Container(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Camera Icon centered over Avatar
                GestureDetector(
                  onTap: controller.changeProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// REUSABLE EDIT INPUT FIELD
/// -----------------------------------------------------------------------
class _EditInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;

  const _EditInputField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
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
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
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
          suffixIcon: Icon(
            icon,
            color: AppColors.primary1,
            size: AppSize.widthPercent(0.048),
          ),
        ),
      ),
    );
  }
}
Widget _defaultAvatar(double size) {
  return Image.asset(
    "assets/images/profile.png",
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      color: AppColors.primary1.withOpacity(0.3),
      child: Icon(
        Icons.person,
        color: AppColors.primary1,
        size: size * 0.5,
      ),
    ),
  );
}