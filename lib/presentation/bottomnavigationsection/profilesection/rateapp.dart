import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/data/controllers/rateappcontroller.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

class Rateapp extends StatelessWidget {
  const Rateapp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<RateAppController>()
        ? Get.find<RateAppController>()
        : Get.put(RateAppController());

    final double horizontalPadding = AppSize.widthPercent(0.055);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
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
                    "Rate App",
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

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppSize.heightPercent(0.06)),

                    /// ================= LOGO =================
                    Image.asset(
                      "assets/images/logo.png",
                      height: AppSize.heightPercent(0.11),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: AppSize.heightPercent(0.055)),

                    /// ================= STARS =================
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final isSelected = index < controller.rating.value;
                          return GestureDetector(
                            onTap: () => controller.setRating(index + 1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.widthPercent(0.012),
                              ),
                              child: Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: AppSize.widthPercent(0.1),
                                color: isSelected
                                    ? AppColors.primary1
                                    : AppColors.primary1.withOpacity(0.45),
                              ),
                            ),
                          );
                        }),
                      );
                    }),

                    SizedBox(height: AppSize.heightPercent(0.02)),

                    Obx(() {
                      final labels = [
                        "",
                        "Poor",
                        "Fair",
                        "Good",
                        "Very Good",
                        "Excellent",
                      ];
                      final r = controller.rating.value;
                      if (r == 0) return const SizedBox.shrink();
                      return Text(
                        labels[r],
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.035),
                        ),
                      );
                    }),

                    SizedBox(height: AppSize.heightPercent(0.04)),

                    /// ================= QUESTION =================
                    Text(
                      "How was your experience?",
                      style: TextStyle(
                        color: AppColors.textcolor1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.042),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.025)),

                    /// ================= FEEDBACK BOX =================
                    Container(
                      width: double.infinity,
                      height: AppSize.heightPercent(0.18),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.widthPercent(0.05),
                        vertical: AppSize.heightPercent(0.02),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: TextField(
                        controller: controller.feedbackController,
                        maxLines: 6,
                        style: TextStyle(
                          color: AppColors.textcolor1,
                          fontFamily: "pr",
                          fontSize: AppSize.widthPercent(0.036),
                        ),
                        decoration: InputDecoration(
                          hintText: "Tell us about your experience (optional)...",
                          hintStyle: TextStyle(
                            color: AppColors.textcolor2.withOpacity(0.55),
                            fontFamily: "pr",
                            fontSize: AppSize.widthPercent(0.032),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: AppColors.primary1,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.05)),

                    /// ================= SUBMIT BUTTON =================
                    Obx(
                          () => CustomButton(
                        title: controller.isSubmitting.value
                            ? "Submitting..."
                            : "Submit",
                        onTap: controller.isSubmitting.value
                            ? null
                            : controller.submit,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.04)),
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
