import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';

import '../../../data/controllers/subcryptioncontroller.dart';

class Subcryption extends StatefulWidget {
  const Subcryption({super.key});

  @override
  State<Subcryption> createState() => _SubcryptionState();
}

class _SubcryptionState extends State<Subcryption> {
  final controller = Get.isRegistered<SubscriptionController>()
      ? Get.find<SubscriptionController>()
      : Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSize.heightPercent(0.02)),

            /// ---------------------------------------------------------
            /// 1. HEADER (Back Button)
            /// ---------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(height: AppSize.heightPercent(0.04)),

                      /// ---------------------------------------------------------
                      /// 2. GLOWING DIAMOND BADGE ICON
                      /// ---------------------------------------------------------
                      Center(
                        child: Container(
                          height: AppSize.widthPercent(0.35),
                          width: AppSize.widthPercent(0.35),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary1.withOpacity(0.1),
                            border: Border.all(
                              color: AppColors.primary1.withOpacity(0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary1.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.diamond_outlined,
                            size: AppSize.widthPercent(0.15),
                            color: AppColors.primary1,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.heightPercent(0.04)),

                      /// ---------------------------------------------------------
                      /// 3. TITLE & SUBTITLE
                      /// ---------------------------------------------------------
                      Text(
                        "Premium Access",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textcolor1,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.06),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSize.heightPercent(0.009)),
                      Text(
                        "A private AI thinking partner for the real life.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textcolor1.withOpacity(0.9),
                          fontFamily: "pr",
                          fontSize: AppSize.widthPercent(0.03),
                        ),
                      ),

                      SizedBox(height: AppSize.heightPercent(0.05)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.widthPercent(0.06),
                          vertical: AppSize.heightPercent(0.03),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1813),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// Pricing Text Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  controller.price.value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "pb",
                                    fontSize: AppSize.widthPercent(0.07),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controller.period.value,
                                  style: TextStyle(
                                    color: AppColors.primary1.withOpacity(0.6),
                                    fontFamily: "pr",
                                    fontSize: AppSize.widthPercent(0.04),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: AppSize.heightPercent(0.03)),

                            /// Features Checklist
                            Column(
                              children: controller.features.map((feature) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppSize.heightPercent(0.02),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2.5),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary1,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: AppSize.widthPercent(0.035),
                                      ),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: TextStyle(
                                            color: AppColors.textcolor1
                                                .withOpacity(0.9),
                                            fontFamily: "pm",
                                            fontSize:
                                            AppSize.widthPercent(0.031),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: AppSize.heightPercent(0.025)),

                           CustomButton(title: "Subscribe Now", onTap: (){
                             AppNavigator.pushRight(AppRoutes.bottomnavigation);
                           }),

                            SizedBox(height: AppSize.heightPercent(0.025)),

                            /// Footer Note
                            Text(
                              "CANCEL ANYTIME. SECURE AND PRIVATE.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontFamily: "pb",
                                fontSize: AppSize.widthPercent(0.026),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSize.heightPercent(0.03)),
                    ],
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