import 'package:get/get.dart';
import 'package:guyline/core/routes/appbinding.dart';
import 'package:guyline/presentation/authsection/changepassword.dart';
import 'package:guyline/presentation/authsection/forgetpassword.dart';
import 'package:guyline/presentation/authsection/loginscreen.dart';
import 'package:guyline/presentation/authsection/privacypolicy.dart';
import 'package:guyline/presentation/authsection/signupscreen.dart';
import 'package:guyline/presentation/authsection/successscreen.dart';
import 'package:guyline/presentation/authsection/terms_condition.dart';
import 'package:guyline/presentation/authsection/verify.dart';
import 'package:guyline/presentation/bottomnavigationsection/bottomnavigation.dart';
import 'package:guyline/presentation/bottomnavigationsection/historysection/historyscreen.dart';
import 'package:guyline/presentation/bottomnavigationsection/homesection/chatbot.dart';
import 'package:guyline/presentation/bottomnavigationsection/homesection/conservation.dart';
import 'package:guyline/presentation/bottomnavigationsection/homesection/homescreen.dart';
import 'package:guyline/presentation/bottomnavigationsection/profilesection/accountsetting.dart';
import 'package:guyline/presentation/bottomnavigationsection/profilesection/editprofile.dart';
import 'package:guyline/presentation/bottomnavigationsection/profilesection/profilescreen.dart';
import 'package:guyline/presentation/bottomnavigationsection/profilesection/subcryption.dart';
import 'package:guyline/presentation/bottomnavigationsection/profilesection/updatepassword.dart';
import 'package:guyline/presentation/onboardingsection/onboardingscreen.dart';
import 'package:guyline/presentation/otherscreens/splashscreen.dart';
import 'package:guyline/presentation/otherscreens/welcomescreen.dart';

import '../../data/controllers/changepasswordcontroller.dart';
import '../../data/controllers/forgetpasswordcontroller.dart';
import '../../data/controllers/verifypasswordcontroller.dart';


class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = "/welcome";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String forget = "/forgget";
  static const String verify = "/verify";
  static const String changepassword = "/changepassword";
  static const String home = "/home";
  static const String chatbot = "/chatbot";
  static const String conservation = "/conservation";
  static const String history = "/history";
  static const String profile = "/profile";
  static const String editprofile = "/editprofile";
  static const String termsandcondition = "/termsandcondition";
  static const String privacypolicy = "/privacypolicy";
  static const String accountsetting = "/accountsetting";
  static const String updatepassword = "/updatepassword";
  static const String success = "/success";
  static const String subcryption = "/subcryption";
  static const String bottomnavigation = "/bottomnavigation";



  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const Splashscreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: bottomnavigation,
      page: () => const Bottomnavigation(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: onboarding,
      page: () => const Onboardingscreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: welcome,
      page: () => const Welcomescreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: login,
      page: () => const Loginscreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signup,
      page: () => const Signupscreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forget,
      binding: ForgetPasswordBinding(),
      page: () => const Forgetpassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: verify,
      page: () => const Verify(),
      binding: VerifyBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: changepassword,
      page: () => const Changepassword(),
      binding: ChangePasswordBinding(),          // ← yeh line zaroori
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const Homescreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: chatbot,
      page: () => const Chatbot(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: conservation,
      page: () => const Conservation(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: history,
      page: () => const HistoryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profile,
      page: () => const Profilescreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: editprofile,
      page: () => const Editprofile(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: accountsetting,
      page: () => const Accountsetting(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: updatepassword,
      page: () => const Updatepassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: termsandcondition,
      page: () => const TermsCondition(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: privacypolicy,
      page: () => const Privacypolicy(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: success,
      page: () => const Successscreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: subcryption,
      page: () => const Subcryption(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}