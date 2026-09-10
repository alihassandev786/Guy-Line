import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import '../Widgets/Button.dart';
import '../Widgets/appbackground.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.05);

    return AppBackground(
      padding: EdgeInsets.zero, // Edge-to-edge layout for top illustration
      child: Stack(
        children: [
          /// 1. TOP ILLUSTRATION IMAGE (Clipped properly at top boundary)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: AppSize.heightPercent(0.55),
            child: Image.asset(
              "assets/images/welcome.png",
              // Temporarily added, change path as needed
              alignment: Alignment.topRight,
            ),
          ),

          /// 2. BOTTOM ROUNDED CONTAINER WITH CARD CONTENT
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: AppSize.heightPercent(0.52),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.widthPercent(0.12)),
                topRight: Radius.circular(AppSize.widthPercent(0.12)),
              ),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50,sigmaY: 50),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary1.withOpacity(0.1),
              
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.widthPercent(0.12)),
                      topRight: Radius.circular(AppSize.widthPercent(0.12)),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSize.heightPercent(0.05),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// TITLE & SUBTITLE SECTION
                      Column(
                        children: [
                          SizedBox(height: AppSize.heightPercent(0.04)),
                          Text(
                            "Welcome To\nGuy Line!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textcolor1,
                              fontFamily: "pb",
                              fontSize: AppSize.widthPercent(0.08),
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: AppSize.heightPercent(0.025)),
                          Text(
                            "Whatever is going on,you can talk\nit through here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textcolor1.withOpacity(0.8),
                              fontFamily: "pr",
                              fontSize: AppSize.widthPercent(0.038),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
              
                      /// ACTION BUTTONS SECTION
                      Column(
                        children: [
                          /// CREATE AN ACCOUNT BUTTON
                          CustomButton(
                            title: "Create an Account",
                            onTap: () {
                              AppNavigator.pushRight(AppRoutes.signup);
                            },
                          ),
              
                          SizedBox(height: AppSize.heightPercent(0.015)),
                          CustomButton(
                            title: "Sign In",
                            onTap: () {
                              AppNavigator.pushRight(AppRoutes.login);
                            },
                            backgroundColor: AppColors.primary2.withOpacity(0.2),
                            borderColor: AppColors.primary1.withOpacity(0.8),
                            textColor: AppColors.primary1,
                          ),
                          SizedBox(height: AppSize.heightPercent(0.01)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
