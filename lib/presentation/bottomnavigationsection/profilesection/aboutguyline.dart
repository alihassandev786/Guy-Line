import 'package:flutter/material.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

class Aboutguyline extends StatelessWidget {
  const Aboutguyline({super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= HEADER =================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSize.heightPercent(0.015),
              ),
              child: Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(width: AppSize.widthPercent(0.04)),
                  Text(
                    "About GuyLine",
                    style: TextStyle(
                      color: AppColors.textcolor1,
                      fontFamily: "pb",
                      fontSize: AppSize.widthPercent(0.055),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            /// ================= CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: AppSize.heightPercent(0.034),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title 1
                    Text(
                      "Your Private AI Companion",
                      style: TextStyle(
                        color: AppColors.textcolor1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.04),
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.015)),

                    /// Paragraph 1
                    Text(
                      "GUY LINE is a private space to talk through whatever’s on your mind. From relationships and work to money, fatherhood, goals, frustration, and difficult decisions — have a conversation, get a different perspective, and figure out what comes next.",
                      style: TextStyle(
                        color: AppColors.textcolor2,
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.031),
                        height: 1.55,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.02)),

                    /// Highlight line
                    Text(
                      "Talk. Think. Move Forward.",
                      style: TextStyle(
                        color: AppColors.textcolor2,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.032),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.02)),

                    /// Paragraph 2
                    Text(
                      "GUY LINE is here to help you make sense of real life, one conversation at a time.",
                      style: TextStyle(
                        color: AppColors.textcolor2,
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.031),
                        height: 1.55,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.03)),

                    /// Title 2
                    Text(
                      "Talk. Think. Move Forward.",
                      style: TextStyle(
                        color: AppColors.textcolor1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.04),
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.02)),

                    /// Paragraph 3
                    Text(
                      "GUY LINE is your private AI companion for talking through real-life situations, getting another perspective, and figuring out what comes next.",
                      style: TextStyle(
                        color: AppColors.textcolor2,
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.031),
                        height: 1.55,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.015)),

                    /// Topics line
                    Text(
                      "Relationships. Work. Money. Fatherhood. Goals.\nDecisions. Whatever’s on your mind.",
                      style: TextStyle(
                        color: AppColors.textcolor1.withOpacity(0.9),
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.031),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.02)),

                    /// Paragraph 4 (repeated as per design)
                    Text(
                      "GUY LINE is your private AI companion for talking through real-life situations, getting another perspective, and figuring out what comes next.",
                      style: TextStyle(
                        color: AppColors.textcolor2,
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.031),
                        height: 1.55,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.02)),

                    /// Topics line again
                    Text(
                      "Relationships. Work. Money. Fatherhood. Goals.\nDecisions. Whatever’s on your mind.",
                      style: TextStyle(
                        color: AppColors.textcolor1.withOpacity(0.9),
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.031),
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.05)),
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