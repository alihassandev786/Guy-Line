import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';

class AccountSettingsController extends GetxController {
  /// -----------------------------------------------------------------
  /// Navigation actions — wire these up to your actual routes/screens.
  /// -----------------------------------------------------------------
  void goBack() => Get.back();

  void goToEditProfile() {
    AppNavigator.pushRight(AppRoutes.editprofile);
  }

  void goToChangePassword() {
    AppNavigator.pushRight(AppRoutes.updatepassword);
  }

  void goToTermsAndConditions() {
    AppNavigator.pushRight(AppRoutes.termsandcondition);
  }

  void goToPrivacyPolicy() {
    AppNavigator.pushRight(AppRoutes.privacypolicy);
  }
}