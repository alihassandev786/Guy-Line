import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Button.dart';
import 'package:guyline/presentation/Widgets/CustomHeader.dart';
import 'package:guyline/presentation/Widgets/iconcircle.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

import '../../../data/controllers/homecontroller.dart';
import '../../Widgets/appbackground.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final double horizontalPadding = AppSize.widthPercent(0.05);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: SingleChildScrollView(
          
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(
                  title: "Hey,Alex!",
                  subtitle: "What's on your mind?",
                  rightWidget: IconCircle(icon: Icons.notifications,backgroundColor: AppColors.primary1,iconColor: AppColors.textcolor1,),
                  profileImage: "assets/images/profile.png",
                ),
                SizedBox(height: AppSize.heightPercent(0.03)),

                // / 2. START TALKING VOICE BUTTON
                GestureDetector(
                  onTap: controller.startTalking,
                  child: Container(
                    width: double.infinity,
                    height: AppSize.heightPercent(0.06),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.widthPercent(0.05),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic_none_rounded,
                          color: Colors.white,
                          size: AppSize.widthPercent(0.065),
                        ),
                        SizedBox(width: AppSize.widthPercent(0.03)),
                        Text(
                          "Start Talking",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "pb",
                            fontSize: AppSize.widthPercent(0.045),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.only(left: 4),
                              width: AppSize.widthPercent(0.018),
                              height: AppSize.widthPercent(0.018),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.03)),

                /// 3. CATEGORIES GRID SECTION
                Obx(
                  () => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSize.widthPercent(0.06),
                      mainAxisSpacing: AppSize.heightPercent(0.02),
                      childAspectRatio: 2.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.categories[index];
                      return GestureDetector(
                        onTap: () => controller.onCategoryTap(item.title),
                        child: Container(
                          decoration: BoxDecoration(
                            color:AppColors.primary2.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                color: item.iconColor,
                                size: AppSize.widthPercent(0.06),
                              ),
                              SizedBox(height: AppSize.heightPercent(0.008)),
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: AppColors.textcolor1,
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.035),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.04)),

                /// 4. CONTINUE WHERE YOU LEFT OFF SECTION
                Text(
                  "Continue Where You Left Off",
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pb",
                    fontSize: AppSize.widthPercent(0.042),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.018)),

                /// 5. RECENT HISTORY LIST
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.recentItems.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSize.heightPercent(0.012)),
                    itemBuilder: (context, index) {
                      final item = controller.recentItems[index];
                      return GestureDetector(
                        onTap: () => controller.onRecentItemTap(item),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.widthPercent(0.045),
                            vertical: AppSize.heightPercent(0.018),
                          ),
                          decoration: BoxDecoration(
                            color:AppColors.primary2.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                              width: 1,
                            ),
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
                                        color: AppColors.textcolor1,
                                        fontFamily: "pb",
                                        fontSize: AppSize.widthPercent(0.038),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSize.heightPercent(0.005),
                                    ),
                                    Text(
                                      item.subtitle,
                                      style: TextStyle(
                                        color: AppColors.textcolor1.withOpacity(
                                          0.5,
                                        ),
                                        fontFamily: "pr",
                                        fontSize: AppSize.widthPercent(0.03),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.primary1,
                                size: AppSize.widthPercent(0.045),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: AppSize.heightPercent(0.03)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
