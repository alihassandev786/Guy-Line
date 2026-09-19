import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/presentation/Widgets/snackbar.dart';
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

  final name = "".obs;
  final email = "".obs;
  final profileImageBase64 = RxnString(); // can be data:image... or http url
  final userId = 0.obs;

  late TextEditingController nameController;
  late TextEditingController emailController;

  final RxnString selectedAvatarPath = RxnString();
  final isLoading = false.obs;
  final avatarVersion = 0.obs;

  // 🔴 Plain (non-reactive) guard against double-tap / double-invocation of
  // saveProfileChanges(). This is checked synchronously the instant the
  // method starts, so unlike isLoading.value (which needs a widget rebuild
  // to visually disable the button), it can never race with a fast
  // double-tap.
  bool _isSaving = false;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    refreshFromSession();
  }

  void refreshFromSession() {
    final user = SessionManager.instance.getUser();
    if (user != null) {
      userId.value = user.id;
      name.value = user.username;
      email.value = user.email;
      profileImageBase64.value = user.profileImage;
      nameController.text = user.username;
      emailController.text = user.email;
      selectedAvatarPath.value = null;
      avatarVersion.value++;
      print("🟣 [ProfileController] Loaded: ${user.username} | image starts with: ${user.profileImage?.substring(0, 30)}");
    }
  }

  ImageProvider? get avatarImageProvider {
    // 1. Local newly picked file
    final localPath = selectedAvatarPath.value;
    if (localPath != null && localPath.isNotEmpty) {
      final file = File(localPath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    final image = profileImageBase64.value;
    if (image == null || image.isEmpty) return null;

    // 2. Base64 pehle (yeh hamesha kaam karta hai)
    if (image.startsWith("data:image")) {
      try {
        final pure = image.contains(',') ? image.split(',').last : image;
        return MemoryImage(base64Decode(pure));
      } catch (e) {
        print("🔴 Base64 decode failed: $e");
        return null;
      }
    }

    // 3. Network URL (sirf jab base64 na ho)
    // Note: backend /storage/... abhi 404 de sakta hai
    if (image.startsWith("http")) {
      return NetworkImage(image);
    }
    return null;
  }

  void changeProfilePicture() {
    ImagePickerBottomSheet.show(
      onCameraTap: () => _pickImage(ImageSource.camera),
      onGalleryTap: () => _pickImage(ImageSource.gallery),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 40,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (pickedFile == null) {
        print("🟡 [ProfileController] No image returned (cancelled or permission denied)");
        return;
      }

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        print("🔴 [ProfileController] Picked file path does not exist: ${pickedFile.path}");
        SnackbarService.error("Selected image could not be read. Please try again.");
        return;
      }

      selectedAvatarPath.value = pickedFile.path;
      avatarVersion.value++;
      print("🟢 Picked: ${pickedFile.path}");
    } catch (e) {
      print("🔴 [ProfileController] Image pick failed: $e");
      SnackbarService.error("Failed to pick image: $e");
    }
  }
  Future<String?> _fileToBase64(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final base64String = base64Encode(bytes);
      final ext = path.toLowerCase().endsWith('.png') ? 'png' : 'jpeg';
      return "data:image/$ext;base64,$base64String";
    } catch (e) {
      print("🔴 Base64 error: $e");
      return null;
    }
  }

  Future<void> saveProfileChanges() async {
    // 🔴 FIX: Guard against double-tap / double-invocation. If a save is
    // already in progress, ignore any extra calls completely.
    if (_isSaving) {
      print("🟡 [ProfileController] saveProfileChanges already in progress — ignoring duplicate call");
      return;
    }
    _isSaving = true;

    final newUsername = nameController.text.trim();

    if (newUsername.isEmpty) {
      SnackbarService.error("Username cannot be empty");
      _isSaving = false;
      return;
    }

    if (userId.value == 0) {
      SnackbarService.error("User session not found");


      _isSaving = false;
      return;
    }

    isLoading.value = true;

    String? imageBase64;
    if (selectedAvatarPath.value != null) {
      imageBase64 = await _fileToBase64(selectedAvatarPath.value!);
    }

    final result = await _authService.editProfile(
      userId: userId.value,
      username: newUsername,
      profileImageBase64: imageBase64,
    );

    isLoading.value = false;

    if (result.success && result.user != null) {
      final updatedUser = result.user!;

      name.value = updatedUser.username;
      email.value = updatedUser.email;
      final serverImage = updatedUser.profileImage;

      if (serverImage != null && serverImage.isNotEmpty) {
        // Backend wali permanent image save karo
        profileImageBase64.value = serverImage;
      } else if (imageBase64 != null && imageBase64.isNotEmpty) {
        // Sirf fallback agar server image na de
        profileImageBase64.value = imageBase64;
      }
      // Agar sirf username change hua (koi nayi image nahi) → purani profileImageBase64 mat chhedo

      selectedAvatarPath.value = null;
      nameController.text = updatedUser.username;
      emailController.text = updatedUser.email;
      avatarVersion.value++;

      final userToSave = UserModel(
        id: updatedUser.id,
        username: updatedUser.username,
        email: updatedUser.email,
        profileImage: profileImageBase64.value, // base64 — permanent until logout
        interests: updatedUser.interests,
        thinkingStyle: updatedUser.thinkingStyle,
        onboardingCompleted: updatedUser.onboardingCompleted,
      );
      await SessionManager.instance.saveUser(userToSave);

      print("✅ Session saved with local base64 (server URL 404 ignored)");
      SnackbarService.success(result.message);


      AppNavigator.pushAndClear(AppRoutes.bottomnavigation);
    } else {
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        name.value = newUsername;
        profileImageBase64.value = imageBase64;
        selectedAvatarPath.value = null;
        nameController.text = newUsername;
        avatarVersion.value++;

        final fallbackUser = UserModel(
          id: userId.value,
          username: newUsername,
          email: email.value,
          profileImage: imageBase64,
        );
        await SessionManager.instance.saveUser(fallbackUser);
      }

      SnackbarService.error(result.message);

    }

    _isSaving = false;
  }

  void discardUnsavedChanges() {
    selectedAvatarPath.value = null;
    nameController.text = name.value;
    emailController.text = email.value;
    avatarVersion.value++;
  }

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
        await SessionManager.instance.clearSession();
        name.value = "";
        email.value = "";
        profileImageBase64.value = null;
        userId.value = 0;
        selectedAvatarPath.value = null;
        nameController.clear();
        emailController.clear();
        avatarVersion.value++;
      },
    );
  }

  void goToAccountSettings() => AppNavigator.pushRight(AppRoutes.accountsetting);
  void goToNotifications() => AppNavigator.pushRight(AppRoutes.notification);
  void goTointrectionprefrence() => AppNavigator.pushRight(AppRoutes.intrectionprefrence);
  void goToSubscription() => AppNavigator.pushRight(AppRoutes.subcryption);
  void goToAbout() => AppNavigator.pushRight(AppRoutes.aboutguyline);
  void goToSupportCenter() => AppNavigator.pushRight(AppRoutes.support);
  void rateApp() => AppNavigator.pushRight(AppRoutes.rateapp);

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}