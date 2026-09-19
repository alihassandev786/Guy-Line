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
import '../../../data/services/subcryptionservice.dart';

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

                      SizedBox(height: AppSize.heightPercent(0.04)),

                      /// ---------------------------------------------------------
                      /// NAYA SECTION: BACKEND SE AAYE HUE PLANS (SELECTABLE)
                      /// ---------------------------------------------------------
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSize.heightPercent(0.03),
                            ),
                            child: CircularProgressIndicator(
                              color: AppColors.primary1,
                            ),
                          );
                        }

                        if (controller.errorMessage.value.isNotEmpty &&
                            controller.plans.isEmpty) {
                          return Column(
                            children: [
                              Text(
                                controller.errorMessage.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: "pm",
                                  fontSize: AppSize.widthPercent(0.032),
                                ),
                              ),
                              SizedBox(height: AppSize.heightPercent(0.015)),
                              GestureDetector(
                                onTap: controller.loadPlans,
                                child: Text(
                                  "Tap to retry",
                                  style: TextStyle(
                                    color: AppColors.primary1,
                                    fontFamily: "pm",
                                    fontSize: AppSize.widthPercent(0.032),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        if (controller.plans.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: controller.plans.map((plan) {
                            final bool isSelected =
                                controller.selectedPlanId.value == plan.id;

                            return GestureDetector(
                              onTap: () => controller.selectPlan(plan),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  bottom: AppSize.heightPercent(0.015),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.widthPercent(0.04),
                                  vertical: AppSize.heightPercent(0.018),
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary1.withOpacity(0.08)
                                      : const Color(0xFF1B1813),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary1
                                        : Colors.white.withOpacity(0.08),
                                    width: isSelected ? 1.6 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: isSelected
                                          ? AppColors.primary1
                                          : Colors.white38,
                                      size: AppSize.widthPercent(0.05),
                                    ),
                                    SizedBox(width: AppSize.widthPercent(0.03)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plan.name,
                                            style: TextStyle(
                                              color: AppColors.textcolor1,
                                              fontFamily: "pb",
                                              fontSize:
                                              AppSize.widthPercent(0.034),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                              AppSize.heightPercent(0.004)),
                                          Text(
                                            "${plan.price}${plan.period}",
                                            style: TextStyle(
                                              color: AppColors.textcolor1
                                                  .withOpacity(0.7),
                                              fontFamily: "pr",
                                              fontSize:
                                              AppSize.widthPercent(0.028),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),

                      SizedBox(height: AppSize.heightPercent(0.02)),

                      /// ---------------------------------------------------------
                      /// SELECTED PLAN DETAIL + SUBSCRIBE BOX (ab reactive hai)
                      /// ---------------------------------------------------------
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
                            /// Pricing Text Row — ab Obx ke andar (reactive fix)
                            Obx(
                                  () => Row(
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
                                      color:
                                      AppColors.primary1.withOpacity(0.6),
                                      fontFamily: "pr",
                                      fontSize: AppSize.widthPercent(0.04),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: AppSize.heightPercent(0.03)),

                            /// Features Checklist — ab Obx ke andar (reactive fix)
                            Obx(
                                  () => Column(
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
                            ),
                            SizedBox(height: AppSize.heightPercent(0.025)),

                            Obx(() => CustomButton(
                              title: controller.isSubscribing.value
                                  ? "Processing..."
                                  : "Subscribe Now",
                              onTap: controller.isSubscribing.value
                                  ? null
                                  : controller.subscribeNow,
                            )),

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