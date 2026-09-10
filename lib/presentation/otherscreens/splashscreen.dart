import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';

import '../../data/services/sessionmanager.dart';
import '../Widgets/appbackground.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  static const String _logoAsset = "assets/images/logo.png";

  @override
  void initState() {
    super.initState();

    // Wait for the first frame to be laid out, then precache the logo
    // so it's fully decoded and ready before we ever try to paint it.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _prepareAndNavigate();
    });
  }

  Future<void> _prepareAndNavigate() async {
    try {
      await precacheImage(const AssetImage(_logoAsset), context);
    } catch (e) {
      print("🔴 [Splashscreen] Failed to precache logo: $e");
    }

    if (!mounted) return;

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      _decideNextRoute();
    });
  }

  /// Checks local session and decides whether to go to
  /// Bottom Navigation (logged in) or Onboarding (not logged in)
  void _decideNextRoute() {
    final bool isLoggedIn = SessionManager.instance.isLoggedIn;
    final user = SessionManager.instance.getUser();

    print("🟡 [Splashscreen] isLoggedIn: $isLoggedIn");
    print("🟡 [Splashscreen] Session User: ${user?.username ?? 'None'}");

    if (isLoggedIn && user != null) {
      print("✅ [Splashscreen] User already logged in, navigating to Bottom Navigation");
      AppNavigator.pushAndClear(AppRoutes.bottomnavigation);
    } else {
      print("🟡 [Splashscreen] No active session, navigating to Onboarding");
      AppNavigator.pushAndClear(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: Image(
          image: const AssetImage(_logoAsset),
          height: AppSize.height * 0.23,
        ),
      ),
    );
  }
}