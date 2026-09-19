import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/CustomHeader.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';

class LegalContentScreen extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  const LegalContentScreen({
    super.key,
    required this.title,
    required this.paragraphs,
  });

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.06);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [

            /// HEADER WITH BACK BUTTON AND TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: CustomHeader(title: title,showBackButton: true,),
            ),

            SizedBox(height: AppSize.heightPercent(0.01)),

            /// PARAGRAPHS LIST VIEW
            Expanded(
              child: SingleChildScrollView(

                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: AppSize.heightPercent(0.01),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    paragraphs.length,
                        (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSize.heightPercent(0.022),
                      ),
                      child: Text(
                        paragraphs[index],
                        style: TextStyle(
                          color: AppColors.textcolor1.withOpacity(0.85),
                          fontFamily: "pr",
                          fontSize: AppSize.widthPercent(0.036),
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}