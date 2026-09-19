import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/CustomHeader.dart';
import 'package:guyline/presentation/Widgets/iconcircle.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/data/services/historyservice.dart';

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
        child: RefreshIndicator(
          color: AppColors.primary1,
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeader(
                    title: "History",
                    subtitle: "Explore your history",
                    rightWidget: GestureDetector(
                      onTap: controller.onSearchTap,
                      child: IconCircle(
                        icon: Icons.search,
                        iconColor: AppColors.textcolor1,
                        backgroundColor: AppColors.primary1,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.heightPercent(0.025)),

                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                              color: AppColors.primary1),
                        ),
                      );
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                controller.errorMessage.value,
                                style: TextStyle(color: AppColors.textcolor2),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: controller.refresh,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Search mode → flat filtered list
                    if (controller.searchQuery.value.isNotEmpty) {
                      if (controller.filteredConversations.isEmpty) {
                        return _emptyState("No results found");
                      }
                      return _buildFlatList(
                          controller.filteredConversations, controller);
                    }

                    // Normal mode → grouped sections
                    final groups = controller.groups;
                    final hasAny = groups.values.any((list) => list.isNotEmpty) ||
                        controller.conversations.isNotEmpty;

                    if (!hasAny) {
                      return _emptyState("No conversations yet");
                    }

                    // If groups are empty but conversations exist (flat fallback)
                    if (groups.isEmpty ||
                        groups.values.every((l) => l.isEmpty)) {
                      return _buildFlatList(
                          controller.conversations, controller);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final entry in groups.entries)
                          if (entry.value.isNotEmpty) ...[
                            if (entry.key != "Today")
                              Padding(
                                padding: EdgeInsets.only(
                                  top: AppSize.heightPercent(0.02),
                                  bottom: AppSize.heightPercent(0.015),
                                ),
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    color: AppColors.textcolor1,
                                    fontFamily: "pb",
                                    fontSize: AppSize.widthPercent(0.042),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            else
                              SizedBox(height: AppSize.heightPercent(0.005)),
                            ...entry.value.map(
                                  (item) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: AppSize.heightPercent(0.012)),
                                child: _HistoryTile(
                                  item: item,
                                  onTap: () => controller.onItemTap(item),
                                ),
                              ),
                            ),
                          ],
                      ],
                    );
                  }),
                  SizedBox(height: AppSize.heightPercent(0.03)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: AppSize.heightPercent(0.15)),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.textcolor2,
            fontFamily: "pr",
            fontSize: AppSize.widthPercent(0.04),
          ),
        ),
      ),
    );
  }

  Widget _buildFlatList(
      List<HistoryConversation> list, HistoryController controller) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          SizedBox(height: AppSize.heightPercent(0.012)),
      itemBuilder: (context, index) {
        final item = list[index];
        return _HistoryTile(
          item: item,
          onTap: () => controller.onItemTap(item),
        );
      },
    );
  }
}

/// Single history card — overflow safe
class _HistoryTile extends StatelessWidget {
  final HistoryConversation item;
  final VoidCallback onTap;

  const _HistoryTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = item.title?.isNotEmpty == true
        ? item.title!
        : (item.category ?? "Conversation");
    final subtitle = item.lastMessage ?? "";
    final category = item.category;
    final time = item.timeAgo ?? "";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.widthPercent(0.04),
          vertical: AppSize.heightPercent(0.018),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left content — takes remaining space
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textcolor1,
                            fontFamily: "pb",
                            fontSize: AppSize.widthPercent(0.04),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.widthPercent(0.02)),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.primary1,
                        size: AppSize.widthPercent(0.06),
                      ),
                    ],
                  ),

                  // Subtitle (last message)
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: AppSize.heightPercent(0.006)),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textcolor2.withOpacity(0.85),
                        fontFamily: "pr",
                        fontSize: AppSize.widthPercent(0.032),
                      ),
                    ),
                  ],

                  SizedBox(height: AppSize.heightPercent(0.012)),

                  // Category chip + time — also overflow safe
                  Row(
                    children: [
                      if (category != null && category.isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.widthPercent(0.03),
                              vertical: AppSize.heightPercent(0.005),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textcolor1.withOpacity(0.85),
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.028),
                              ),
                            ),
                          ),
                        ),
                      if (category != null &&
                          category.isNotEmpty &&
                          time.isNotEmpty)
                        SizedBox(width: AppSize.widthPercent(0.025)),
                      if (time.isNotEmpty)
                        Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textcolor2.withOpacity(0.7),
                            fontFamily: "pr",
                            fontSize: AppSize.widthPercent(0.028),
                          ),
                        ),
                    ],
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