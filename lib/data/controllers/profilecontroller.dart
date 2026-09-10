import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/ImagePickerBottomSheet.dart';
import 'package:guyline/presentation/Widgets/Customdiologe/CustomDiologe.dart';
import '../services/authservice.dart';
import '../services/sessionmanager.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  // -------------------- Reactive User Data --------------------
  final name = "".obs;
  final email = "".obs;
  final profileImageBase64 = RxnString(); // from backend (data:image/...;base64,...)
  final userId = 0.obs;

  // Text Controllers
  late TextEditingController nameController;
  late TextEditingController emailController;

  // Default Assets
  final String defaultBannerImage = "assets/images/profile.png";
  final String defaultAvatarImage = "assets/images/profile.png";

  // Local picked images (only path)
  final RxnString selectedBannerPath = RxnString();
  final RxnString selectedAvatarPath = RxnString();

  // Loading
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    _loadUserFromSession();
  }
  // -------------------- Load Current User --------------------
  void _loadUserFromSession() {
    final user = SessionManager.instance.getUser();
    if (user != null) {
      userId.value = user.id;
      name.value = user.username;
      email.value = user.email;
      profileImageBase64.value = user.profileImage;
      nameController.text = user.username;
      emailController.text = user.email;
      print("🟣 [ProfileController] Loaded user: ${user.username} (ID: ${user.id})");
    } else {
      print("🔴 [ProfileController] No user found in session");
    }
  }

  // -------------------- Image Pickers --------------------
  void changeBannerImage() {
    ImagePickerBottomSheet.show(
      onCameraTap: () => _pickImage(ImageSource.camera, isBanner: true),
      onGalleryTap: () => _pickImage(ImageSource.gallery, isBanner: true),
    );
  }

  void changeProfilePicture() {
    ImagePickerBottomSheet.show(
      onCameraTap: () => _pickImage(ImageSource.camera, isBanner: false),
      onGalleryTap: () => _pickImage(ImageSource.gallery, isBanner: false),
    );
  }

// Purana _pickImage method hatao
// Aur yeh naya wala laga do

  Future<void> _pickImage(ImageSource source, {required bool isBanner}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 40,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final sizeInKB = await file.length() / 1024;
        print("🟢 [ProfileController] Picked image size: ${sizeInKB.toStringAsFixed(1)} KB");

        if (isBanner) {
          selectedBannerPath.value = pickedFile.path;
        } else {
          selectedAvatarPath.value = pickedFile.path;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
  // -------------------- Convert File → Base64 --------------------
  Future<String?> _fileToBase64(String path) async {
    try {
      // 1. Pehle image ko resize + compress karo
      final File originalFile = File(path);

      // image_picker already quality de chuka hai, lekin ab aur compress karte hain
      final bytes = await originalFile.readAsBytes();

      // Agar image 300KB se badi hai to quality aur kam karo
      // (simple way - abhi ke liye quality 40-50 enough hai)

      // Better way: use flutter_image_compress (recommended)
      // Agar package nahi lagana to neeche wala simple method use karo

      final base64String = base64Encode(bytes);

      // Size check
      final sizeInKB = (base64String.length * 0.75) / 1024;
      print("🟢 [ProfileController] Image size after base64: ${sizeInKB.toStringAsFixed(1)} KB");

      if (sizeInKB > 400) {
        print("🔴 [ProfileController] Image too large (${sizeInKB.toStringAsFixed(1)} KB). Compress more.");
        // Yahan aap additional compression laga sakte ho
      }

      final ext = path.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      return "data:image/$ext;base64,$base64String";
    } catch (e) {
      print("🔴 [ProfileController] Base64 conversion error: $e");
      return null;
    }
  }
  // -------------------- Save Profile (API Call) --------------------
  Future<void> saveProfileChanges() async {
    final String newUsername = nameController.text.trim();

    if (newUsername.isEmpty) {
      Get.snackbar(
        "Error",
        "Username cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (userId.value == 0) {
      Get.snackbar(
        "Error",
        "User session not found. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    print("🟡 [ProfileController] Saving profile for userId: ${userId.value}");

    // Convert avatar if newly picked
    String? imageBase64;
    if (selectedAvatarPath.value != null) {
      imageBase64 = await _fileToBase64(selectedAvatarPath.value!);
      print("🟢 [ProfileController] Avatar converted to base64");
    } else {
      // keep existing one if available
      imageBase64 = profileImageBase64.value;
    }

    final AuthResult result = await _authService.editProfile(
      userId: userId.value,
      username: newUsername,
      profileImageBase64: imageBase64,
    );

    isLoading.value = false;

    if (result.success && result.user != null) {
      print("✅ [ProfileController] Profile updated successfully");

      // Update local reactive values
      name.value = result.user!.username;
      email.value = result.user!.email;
      profileImageBase64.value = result.user!.profileImage;
      selectedAvatarPath.value = null; // clear local path after success

      // Save updated user in session
      await SessionManager.instance.saveUser(result.user!);

      Get.snackbar(
        "Success",
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Go back to profile / bottom nav
      AppNavigator.pushRight(AppRoutes.bottomnavigation);
    } else {
      print("❌ [ProfileController] Update failed: ${result.message}");
      Get.snackbar(
        "Update Failed",
        result.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // -------------------- Logout (with real session clear) --------------------
  void logout(BuildContext context) {
    CustomAlertDialog.show(
      context: context,
      title: "Logout",
      subtitle: "Are you sure you want to log out of your account?",
      icon: Icons.logout_rounded,
      confirmText: "Logout",
      cancelText: "Cancel",
      iconColor: const Color(0xFFD32F2F),
      confirmColor: const Color(0xFFD32F2F),
      navigateToLoginOnConfirm: true,
      onConfirm: () async {
        print("🟡 [ProfileController] Logging out...");
        await SessionManager.instance.clearSession();
        print("✅ [ProfileController] Session cleared successfully");
      },
    );
  }

  // -------------------- Navigation Methods --------------------
  void goToAccountSettings() {
    AppNavigator.pushRight(AppRoutes.accountsetting);
  }

  void goToNotifications() {
    Get.snackbar("Coming Soon", "Notifications settings will be available soon",
        snackPosition: SnackPosition.BOTTOM);
  }

  void goToPrivacyAndSecurity() {
    AppNavigator.pushRight(AppRoutes.privacypolicy);
  }

  void goToSubscription() {
    AppNavigator.pushRight(AppRoutes.subcryption);
  }

  void goToAbout() {
    AppNavigator.pushRight(AppRoutes.termsandcondition);
  }

  void goToSupportCenter() {
    Get.snackbar("Coming Soon", "Support Center will be available soon",
        snackPosition: SnackPosition.BOTTOM);
  }

  void rateApp() {
    Get.snackbar("Thank You!", "Redirecting to app store...",
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}