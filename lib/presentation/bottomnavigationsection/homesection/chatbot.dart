import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/appbackground1.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';
import '../../../data/controllers/conservationcontroller.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final controller = Get.isRegistered<ConversationController>()
      ? Get.find<ConversationController>()
      : Get.put(ConversationController());

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.045);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.goBack();
        },
        child: AppBackground1(
          padding: EdgeInsets.zero,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppSize.heightPercent(0.02)),

                  /// HEADER
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(
                        onTap: () => controller.goBack(),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      SizedBox(height: AppSize.height * 0.04),
                      Image(
                        image: const AssetImage("assets/images/onb1.png"),
                        height: AppSize.height * 0.16,
                      ),
                      SizedBox(height: AppSize.heightPercent(0.05)),
                      Obx(
                            () => Text(
                          "Hello ${controller.userName.value}!",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontFamily: "pr",
                            fontSize: AppSize.widthPercent(0.04),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.heightPercent(0.012)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.widthPercent(0.12),
                        ),
                        child: Text(
                          "How can I help you today?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "pb",
                            fontSize: AppSize.widthPercent(0.062),
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.heightPercent(0.035)),

                      /// SUGGESTION CHIPS
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Row(
                          children: List.generate(
                            controller.suggestionChips.length,
                                (index) {
                              final chip = controller.suggestionChips[index];
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.height * 0.003,
                                  ),
                                  child: _SuggestionChip(
                                    label: chip,
                                    onTap: () =>
                                        controller.onSuggestionTap(chip),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.heightPercent(0.025)),

                      /// INPUT BAR
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          AppSize.heightPercent(0.025),
                        ),
                        child: Container(
                          height: AppSize.height * 0.062,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.widthPercent(0.045),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller:
                                  controller.assistantInputController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "pr",
                                    fontSize: AppSize.widthPercent(0.037),
                                  ),
                                  cursorColor: AppColors.primary1,
                                  onChanged: (_) => setState(() {}),
                                  onSubmitted: (_) =>
                                      controller.sendFromChatbot(),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ask anything...",
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.45),
                                      fontFamily: "pr",
                                      fontSize: AppSize.widthPercent(0.037),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                    () => GestureDetector(
                                  onTap: controller.isSendingMessage.value
                                      ? null
                                      : () {
                                    final text = controller
                                        .assistantInputController.text
                                        .trim();
                                    if (text.isEmpty) {
                                      controller.onMicTap();
                                    } else {
                                      controller.sendFromChatbot();
                                    }
                                  },
                                  child: controller.isSendingMessage.value
                                      ? SizedBox(
                                    height: AppSize.widthPercent(0.05),
                                    width: AppSize.widthPercent(0.05),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary1,
                                    ),
                                  )
                                      : Icon(
                                    controller.assistantInputController.text
                                        .trim()
                                        .isEmpty
                                        ? Icons.graphic_eq_rounded
                                        : Icons.send_rounded,
                                    color: AppColors.primary1,
                                    size: AppSize.widthPercent(0.06),
                                  ),
                                ),
                              ),                        ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        );
    }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSize.height * 0.045,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.primary1.withOpacity(0.55),
            width: 1.2,
          ),
          color: AppColors.primary2.withOpacity(0.2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.background,
            fontFamily: "pr",
            fontSize: AppSize.widthPercent(0.030),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}