import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/AppNavigator.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Textfield.dart';
import 'package:guyline/presentation/Widgets/appbackground1.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
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
    final double horizontalPadding = AppSize.widthPercent(0.055);

    return AppBackground1(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: AppSize.heightPercent(0.02)),

              /// ---------------------------------------------------------
              /// 1. HEADER — back button only
              /// ---------------------------------------------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackButton(),
                ),
              ),

              /// ---------------------------------------------------------
              /// 2. CENTERED GRAPHIC + GREETING
              /// ---------------------------------------------------------
              Column(
                children: [
                  SizedBox(height: AppSize.height * 0.1),
                  Image(
                    image: AssetImage("assets/images/onb1.png"),
                    height: AppSize.height * 0.16,
                  ),
                  SizedBox(height: AppSize.heightPercent(0.06)),
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
                  SizedBox(height: AppSize.heightPercent(0.01)),
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
                        fontSize: AppSize.widthPercent(0.06),
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.height * 0.08),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.height * 0.02,
                    ),
                    child: CustomTextField(
                      hintText: "Ask anything...",
                      focusedBorderColor: AppColors.primary1,
                      suffixIcon: GestureDetector(
                        onTap: (){
                          AppNavigator.pushRight(AppRoutes.conservation);
                        },
                        child: Icon(
                          Icons.graphic_eq_rounded,
                          color: AppColors.primary1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
