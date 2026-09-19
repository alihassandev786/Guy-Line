import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';
import '../../../data/controllers/featurecontroller.dart';

/// -----------------------------------------------------------------------
/// HELP ME SAY IT — Bottom Sheet (reusable from Chatbot & Conversation)
/// -----------------------------------------------------------------------
class HelpMeSayItBottomSheet extends StatelessWidget {
  const HelpMeSayItBottomSheet({super.key});

  static void show() {
    final controller = Get.isRegistered<FeatureController>()
        ? Get.find<FeatureController>()
        : Get.put(FeatureController());

    controller.loadSayItDraft();

    Get.bottomSheet(
      HelpMeSayItBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
    );
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<FeatureController>()
        ? Get.find<FeatureController>()
        : Get.put(FeatureController());

    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: AppSize.height * 0.88),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1F1A12), Color(0xFF141414), Color(0xFF0A0A0A)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSize.widthPercent(0.05),
                AppSize.heightPercent(0.04),
                AppSize.widthPercent(0.05),
                bottomPad + AppSize.heightPercent(0.07),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title row
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary1.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: AppColors.primary1,
                          size: 22,
                        ),
                      ),
                      SizedBox(width: AppSize.widthPercent(0.03)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.sayItTitle.value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "pb",
                                  fontSize: AppSize.widthPercent(0.05),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.sayItSubtitle.value,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.032),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.heightPercent(0.035)),

                  /// Generated text card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary2.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary1.withOpacity(0.25),
                      ),
                    ),
                    child: IntrinsicHeight(   // important — so left bar takes full height of content
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// Left accent bar
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              color: AppColors.primary1,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),

                          /// Content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                AppSize.widthPercent(0.1),
                                AppSize.widthPercent(0.045),
                                AppSize.widthPercent(0.045),
                                AppSize.widthPercent(0.045),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                        () => controller.isGeneratingSayIt.value
                                        ? SizedBox(
                                      height: AppSize.widthPercent(0.05),
                                      width: AppSize.widthPercent(0.05),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary1,
                                      ),
                                    )
                                        : Text(
                                      controller.generatedText.value,
                                      style: TextStyle(
                                        color: AppColors.background,
                                        fontFamily: "pr",
                                        fontSize: AppSize.widthPercent(0.03),
                                        height: 1.45,
                                      ),
                                    ),
                                  ),                                  SizedBox(height: AppSize.heightPercent(0.02)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _SmallActionBtn(
                                        icon: Icons.copy_rounded,
                                        label: "Copy",
                                        onTap: controller.copyGeneratedText,
                                        filled: false,
                                      ),
                                      SizedBox(width: AppSize.widthPercent(0.025)),
                                      _SmallActionBtn(
                                        icon: Icons.send_rounded,
                                        label: "Send",
                                        onTap: controller.sendGeneratedTextToChat,
                                        filled: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.heightPercent(0.05)),

                  /// Tone chips
                  Row(
                    children: List.generate(controller.sayItChips.length, (i) {
                      final chip = controller.sayItChips[i];
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.widthPercent(0.01),
                          ),
                          child: GestureDetector(
                            onTap: () => controller.onSayItChipTap(chip),
                            child: Container(
                              height: AppSize.height * 0.045,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.primary1.withOpacity(0.55),
                                ),
                                color: AppColors.primary2.withOpacity(0.15),
                              ),
                              child: Text(
                                chip,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.03),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: AppSize.heightPercent(0.03)),

                  /// Custom input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: AppSize.height * 0.058,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.widthPercent(0.04),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: TextField(
                            controller: controller.sayItInputController,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "pr",
                              fontSize: AppSize.widthPercent(0.035),
                            ),
                            cursorColor: AppColors.primary1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Or Type how you want to change it...",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.45),
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.025),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.widthPercent(0.025)),
                      GestureDetector(
                        onTap: controller.sendSayItCustomText,
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
                  SizedBox(height: AppSize.height*0.015,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _SmallActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.widthPercent(0.028),
          vertical: AppSize.heightPercent(0.007),
        ),
        decoration: BoxDecoration(
          color: filled ? AppColors.primary1 : AppColors.primary2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.primary1.withOpacity(filled ? 0 : 0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: filled ? Colors.white : AppColors.background,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.white : AppColors.background,
                fontFamily: "ps",
                fontSize: AppSize.widthPercent(0.032),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
