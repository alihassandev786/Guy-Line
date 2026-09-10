import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

class Successscreen extends StatefulWidget {
  const Successscreen({super.key});

  @override
  State<Successscreen> createState() => _SuccessscreenState();
}

class _SuccessscreenState extends State<Successscreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.06);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Stack(
          children: [

            /// ================= MAIN CONTENT =================
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          SizedBox(
                            height: AppSize.heightPercent(0.015),
                          ),

                          /// 1. TOP BACK BUTTON
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomBackButton(),
                          ),

                          /// 2. SPACE
                          /// Pehle 0.33 tha jo overflow create kar raha tha
                          SizedBox(
                            height: AppSize.heightPercent(0.22),
                          ),

                          /// 3. TITLE
                          Text(
                            "Password Changed!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textcolor1,
                              fontFamily: "pb",
                              fontSize: AppSize.widthPercent(0.065),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            height: AppSize.heightPercent(0.02),
                          ),

                          /// 4. SUBTITLE
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.widthPercent(0.03),
                            ),
                            child: Text(
                              "Your password has been successfully updated.\n"
                                  "You can now log in with your new password!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                AppColors.textcolor1.withOpacity(0.8),
                                fontFamily: "pr",
                                fontSize:
                                AppSize.widthPercent(0.035),
                                height: 1.4,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: AppSize.heightPercent(0.06),
                          ),

                          /// 5. LOGIN NOW BUTTON
                          CustomButton(
                            title: "Login Now",
                            onTap: () {
                              // Keyboard agar open ho to pehle close karo
                              FocusManager.instance.primaryFocus?.unfocus();

                              // Password reset flow ki purani screens remove
                              Get.offAllNamed(AppRoutes.login);
                            },
                          ),

                          SizedBox(
                            height: AppSize.heightPercent(0.03),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ================= CONFETTI ANIMATION =================
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,

                  // Neechay ki taraf
                  blastDirection: math.pi / 2,

                  blastDirectionality:
                  BlastDirectionality.explosive,

                  emissionFrequency: 0.06,
                  numberOfParticles: 14,

                  maxBlastForce: 22,
                  minBlastForce: 10,

                  gravity: 0.25,
                  shouldLoop: false,

                  colors: const [
                    Colors.blue,
                    Colors.green,
                    Colors.pinkAccent,
                    Colors.orange,
                    Colors.redAccent,
                    Colors.amber,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}