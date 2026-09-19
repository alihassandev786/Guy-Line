import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import '../../../data/controllers/featurecontroller.dart';

class Makeaplan extends StatefulWidget {
  const Makeaplan({super.key});

  @override
  State<Makeaplan> createState() => _MakeaplanState();
}

class _MakeaplanState extends State<Makeaplan> {
  final controller = Get.isRegistered<FeatureController>()
      ? Get.find<FeatureController>()
      : Get.put(FeatureController());

  @override
  void initState() {
    super.initState();
    controller.loadPlanSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    final hp = AppSize.widthPercent(0.05);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSize.heightPercent(0.015)),

            /// Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(width: AppSize.widthPercent(0.03)),
                  Text(
                    "Make a Plan",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "pb",
                      fontSize: AppSize.widthPercent(0.05),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSize.heightPercent(0.025)),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: hp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Intro card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSize.widthPercent(0.04)),
                      decoration: BoxDecoration(
                        color: AppColors.primary2.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppSize.height * 0.02,
                        ),
                      ),
                      child: Obx(
                        () => Text(
                          controller.planIntro.value,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontFamily: "pr",
                            fontSize: AppSize.widthPercent(0.035),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.03)),

                    Text(
                      "Suggestions",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.045),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.018)),

                    /// Plan items
                    Obx(
                          () {
                        if (controller.isLoadingPlan.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSize.heightPercent(0.04),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.primary1),
                            ),
                          );
                        }
                        return Column(
                          children: List.generate(controller.planItems.length, (i) {
                            final item = controller.planItems[i];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: AppSize.heightPercent(0.012),
                              ),
                              child: GestureDetector(
                                onTap: () => controller.togglePlanItem(i),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(AppSize.widthPercent(0.04)),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary2.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppSize.height * 0.02),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "pb",
                                                fontSize: AppSize.widthPercent(0.038),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (item.description.isNotEmpty) ...[
                                              SizedBox(height: AppSize.heightPercent(0.006)),
                                              Text(
                                                item.description,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.6),
                                                  fontFamily: "pr",
                                                  fontSize: AppSize.widthPercent(0.031),
                                                  height: 1.35,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: AppSize.widthPercent(0.03)),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: item.isSelected.value
                                                ? AppColors.primary1
                                                : Colors.white.withOpacity(0.4),
                                            width: 2,
                                          ),
                                          color: item.isSelected.value
                                              ? AppColors.primary1
                                              : Colors.transparent,
                                        ),
                                        child: item.isSelected.value
                                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    SizedBox(height: AppSize.heightPercent(0.03)),

                    /// Add to Plan button
                    Obx(() {
                      final count = controller.selectedPlanCount;
                      return GestureDetector(
                        onTap: controller.addSelectedToPlan,
                        child: Container(
                          width: double.infinity,
                          height: AppSize.height * 0.06,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary1,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            count == 0 ? "Add to Plan" : "Add $count to Plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "ps",
                              fontSize: AppSize.widthPercent(0.04),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: AppSize.heightPercent(0.03)),
                  ],
                ),
              ),
            ),

            /// Bottom input
            Container(
              padding: EdgeInsets.fromLTRB(
                hp,
                AppSize.heightPercent(0.02),
                hp,
                AppSize.heightPercent(0.02),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary2.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSize.height * 0.06,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.widthPercent(0.04),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.planInputController,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.035),
                              ),
                              cursorColor: AppColors.primary1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type message to adjust the plan..",
                                hintStyle: TextStyle(
                                  color: AppColors.textcolor2,
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.028),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.white.withOpacity(0.6),
                            size: AppSize.widthPercent(0.055),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.widthPercent(0.025)),
                  GestureDetector(
                    onTap: controller.sendPlanCustomText,
                    child: Container(
                      height: AppSize.widthPercent(0.125),
                      width: AppSize.widthPercent(0.125),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary1,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary1.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: AppSize.widthPercent(0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
