import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import '../../../data/controllers/featurecontroller.dart';

class Helpmedecide extends StatefulWidget {
  const Helpmedecide({super.key});

  @override
  State<Helpmedecide> createState() => _HelpmedecideState();
}

class _HelpmedecideState extends State<Helpmedecide> {
  final controller = Get.isRegistered<FeatureController>()
      ? Get.find<FeatureController>()
      : Get.put(FeatureController());

  @override
  void initState() {
    super.initState();
    // Build complete hone ke baad call karo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDecideAnalysis();
    });
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
                    "Help Me Decide",
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
                  children: [
                    /// AI Summary card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSize.widthPercent(0.05)),
                      decoration: BoxDecoration(
                        color: AppColors.primary2.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary1.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.psychology_outlined,
                              color: AppColors.primary1,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: AppSize.widthPercent(0.03)),
                          Expanded(
                            child: Obx(
                                  () => Text(
                                controller.decideSummary.value,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.028),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.025)),

                    /// Option cards
                    Obx(() {
                      if (controller.isLoadingDecide.value) {
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
                        children: controller.decideOptions.map((option) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: AppSize.heightPercent(0.02),
                            ),
                            child: _OptionCard(
                              option: option,
                              onSelect: () => controller.selectDecideOption(option),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: AppSize.heightPercent(0.02)),
                  ],
                ),
              ),
            ),

            /// Bottom input
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary2.withOpacity(0.1)
              ),
              padding: EdgeInsets.fromLTRB(
                hp,
                AppSize.heightPercent(0.02),
                hp,
                AppSize.heightPercent(0.02),
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
                              controller: controller.decideInputController,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.035),
                              ),
                              cursorColor: AppColors.primary1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type your response...",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.45),
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.033),
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
                    onTap: controller.sendDecideCustomText,
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

class _OptionCard extends StatelessWidget {
  final DecideOption option;
  final VoidCallback onSelect;

  const _OptionCard({required this.option, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary2.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Container(
            padding: EdgeInsets.symmetric(vertical: AppSize.width*0.055,horizontal:AppSize.width*0.04),
            decoration: BoxDecoration(
              color: AppColors.primary2.withOpacity(0.1)
            ),
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary1.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.grid_view_rounded,
                    color: AppColors.primary1,
                    size: 18,
                  ),
                ),
                SizedBox(width: AppSize.widthPercent(0.025)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: AppColors.primary1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.04),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.03),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          SizedBox(height: AppSize.heightPercent(0.018)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.width*0.06,horizontal:AppSize.width*0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...option.pros.map(
                      (p) => Padding(
                    padding: EdgeInsets.only(bottom: AppSize.heightPercent(0.023)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.greenAccent.withOpacity(0.85), size: 18),
                        SizedBox(width: AppSize.widthPercent(0.02)),
                        Expanded(
                          child: Text(
                            p,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontFamily: "pr",
                              fontSize: AppSize.widthPercent(0.033),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(color: Colors.white.withOpacity(0.12), height: AppSize.height*0.03),
                SizedBox(height: AppSize.height*0.02),

                /// Cons
                ...option.cons.map(
                      (c) => Padding(
                    padding: EdgeInsets.only(bottom: AppSize.heightPercent(0.023)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.remove_circle_outline,
                            color: Colors.redAccent.withOpacity(0.85), size: 18),
                        SizedBox(width: AppSize.widthPercent(0.02)),
                        Expanded(
                          child: Text(
                            c,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontFamily: "pr",
                              fontSize: AppSize.widthPercent(0.033),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.015)),
                GestureDetector(
                  onTap: onSelect,
                  child: Container(
                    width: double.infinity,
                    height: AppSize.height * 0.055,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Select ${option.title}",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ps",
                        fontSize: AppSize.widthPercent(0.038),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSize.height*0.012,),


              ],
            ),
          ),

          /// Pros



          /// Select button
        ],
      ),
    );
  }
}
