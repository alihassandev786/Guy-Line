import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/CustomHeader.dart';
import 'package:guyline/presentation/Widgets/iconcircle.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

import '../../../data/controllers/historycontroller.dart';
import '../../Widgets/appbackground.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController());

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
                  title: "History",
                  subtitle: "Explore your history",
                  rightWidget: IconCircle(
                    icon: Icons.search,
                    iconColor: AppColors.textcolor1,
                    backgroundColor: AppColors.primary1,
                  ),
                ),
                SizedBox(height: AppSize.heightPercent(0.025)),

                /// 2. HISTORY SECTIONS LIST
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.historySections.length,
                    itemBuilder: (context, sectionIndex) {
                      final section = controller.historySections[sectionIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (section.sectionTitle != null) ...[
                            SizedBox(height: AppSize.heightPercent(0.025)),
                            Text(
                              section.sectionTitle!,
                              style: TextStyle(
                                color: AppColors.textcolor1,
                                fontFamily: "pb",
                                fontSize: AppSize.widthPercent(0.045),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppSize.heightPercent(0.015)),
                          ],
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: section.items.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: AppSize.heightPercent(0.012)),
                            itemBuilder: (context, itemIndex) {
                              final item = section.items[itemIndex];
                              return GestureDetector(
                                onTap: () => controller.onItemTap(item),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    AppSize.widthPercent(0.05),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary2.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                color: AppColors.textcolor1,
                                                fontFamily: "pb",
                                                fontSize: AppSize.widthPercent(
                                                  0.04,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.primary1,
                                            size: AppSize.widthPercent(0.04),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: AppSize.heightPercent(0.005),
                                      ),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                          color: AppColors.textcolor1,
                                          fontFamily: "pr",
                                          fontSize: AppSize.widthPercent(0.032),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: AppSize.heightPercent(0.015),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppSize.widthPercent(
                                                0.035,
                                              ),
                                              vertical: AppSize.heightPercent(
                                                0.008,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.textcolor1.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item.tag,
                                              style: TextStyle(
                                                color: AppColors.textcolor1
                                                    .withOpacity(0.8),
                                                fontFamily: "pr",
                                                fontSize: AppSize.widthPercent(
                                                  0.028,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (item.timeAgo.isNotEmpty) ...[
                                            SizedBox(
                                              width: AppSize.widthPercent(0.03),
                                            ),
                                            Text(
                                              item.timeAgo,
                                              style: TextStyle(
                                                color: AppColors.textcolor2,
                                                fontFamily: "pr",
                                                fontSize: AppSize.widthPercent(
                                                  0.028,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
