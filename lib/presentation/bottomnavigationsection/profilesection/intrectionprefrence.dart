import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

import '../../../data/controllers/intrectionprefrencecontroller.dart';

class Intrectionprefrence extends StatelessWidget {
  const Intrectionprefrence({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<InteractionPreferenceController>()
        ? Get.find<InteractionPreferenceController>()
        : Get.put(InteractionPreferenceController());
    final double horizontalPadding = AppSize.widthPercent(0.05);

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
                  Expanded(
                    child: Text(
                      "Interaction Preference",
                      style: TextStyle(
                        color: AppColors.textcolor1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.05),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSize.heightPercent(0.05)),

            /// ================= SUBTITLE =================
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Choose how you’d like GuyLine to interact with you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textcolor2,
                    fontFamily: "pr",
                    fontSize: AppSize.widthPercent(0.03),
                    height: 1.4,
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSize.heightPercent(0.06)),

            /// ================= OPTIONS LIST =================
            /// Obx zaroori hai taake selectedIndex change pe UI turant update ho
            Expanded(
              child: Obx(() {
                final selected = controller.selectedIndex.value;
                final loading = controller.isLoading.value;

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: controller.options.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: AppSize.heightPercent(0.01)),
                  itemBuilder: (context, index) {
                    final option = controller.options[index];
                    final isSelected = selected == index;

                    return GestureDetector(
                      onTap: loading
                          ? null
                          : () => controller.selectOption(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.widthPercent(0.04),
                          vertical: AppSize.heightPercent(0.02),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary1.withOpacity(0.15)
                              : AppColors.primary2.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary1
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            /// Left Icon Circle
                            Container(
                              height: AppSize.widthPercent(0.11),
                              width: AppSize.widthPercent(0.11),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary1.withOpacity(0.18),
                              ),
                              child: Icon(
                                option.icon,
                                color: AppColors.primary1,
                                size: AppSize.widthPercent(0.05),
                              ),
                            ),

                            SizedBox(width: AppSize.widthPercent(0.035)),

                            /// Title + Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: TextStyle(
                                      color: AppColors.textcolor1,
                                      fontFamily: "pb",
                                      fontSize: AppSize.widthPercent(0.036),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppSize.heightPercent(0.006),
                                  ),
                                  Text(
                                    option.subtitle,
                                    style: TextStyle(
                                      color: AppColors.textcolor2,
                                      fontFamily: "pr",
                                      fontSize: AppSize.widthPercent(0.028),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Right Radio / Check
                            Container(
                              height: AppSize.widthPercent(0.06),
                              width: AppSize.widthPercent(0.06),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary1
                                    : Colors.transparent,
                                border: Border.all(
                                  color: AppColors.primary1,
                                  width: 1.8,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                Icons.check,
                                size: AppSize.widthPercent(0.038),
                                color: Colors.black,
                              )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            /// ================= SAVE BUTTON =================
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSize.heightPercent(0.0),
                horizontalPadding,
                AppSize.heightPercent(0.19),
              ),
              child: Obx(
                    () => CustomButton(
                  title: controller.isLoading.value
                      ? "Saving..."
                      : "Save Changes",
                  onTap: controller.isLoading.value
                      ? null
                      : controller.saveChanges,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
