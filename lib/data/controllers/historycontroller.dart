import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/data/services/historyservice.dart';
import 'package:guyline/data/services/sessionmanager.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';

import '../../core/routes/approutes.dart';
import '../../core/theme/appcolors.dart';
import 'conservationcontroller.dart';

class HistoryController extends GetxController {
  final HistoryService _historyService = HistoryService();

  final isLoading = false.obs;
  final errorMessage = "".obs;
  final conversations = <HistoryConversation>[].obs;
  final filteredConversations = <HistoryConversation>[].obs;

  /// Grouped history for section headers (Today / Yesterday / Previous 7 Days / Older)
  final groups = <String, List<HistoryConversation>>{}.obs;

  final searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  @override
  void onReady() {
    super.onReady();
    loadHistory();
  }

  Future<void> loadHistory() async {
    if (SessionManager.instance.getUser() == null) {
      errorMessage.value = "Please login first";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    final result = await _historyService.getHistory();

    isLoading.value = false;

    if (result.success) {
      conversations.assignAll(result.conversations);
      filteredConversations.assignAll(result.conversations);
      groups.assignAll(result.groups);
      print("✅ Loaded ${conversations.length} conversations");
    } else {
      errorMessage.value = result.message;
    }
  }

  Future<void> onItemTap(HistoryConversation item) async {
    final conv = Get.isRegistered<ConversationController>()
        ? Get.find<ConversationController>()
        : Get.put(ConversationController());

    // Category hi conversation top pe topic banega (General pe empty)
    // Tile ka title (pehla message) History list ke liye alag rehta hai
    await conv.loadExistingConversation(
      item.id,
      title: item.title,
      category: item.category,
    );

    Get.toNamed(AppRoutes.conservation);
  }

  void onSearchTap() {
    final TextEditingController searchCtrl =
    TextEditingController(text: searchQuery.value);

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Search History",
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pb",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Find conversations by title or topic",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor1.withOpacity(0.55),
                  fontFamily: "pr",
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: AppSize.height * 0.058,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(AppSize.height * 0.03),
                  border: Border.all(
                    color: AppColors.primary1.withOpacity(0.35),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: searchCtrl,
                  autofocus: true,
                  style: TextStyle(
                    color: AppColors.textcolor1,
                    fontFamily: "pr",
                    fontSize: 15,
                  ),
                  cursorColor: AppColors.primary1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: "Search conversations...",
                    hintStyle: TextStyle(
                      color: AppColors.textcolor1.withOpacity(0.4),
                      fontFamily: "pr",
                      fontSize: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary1,
                      size: 22,
                    ),
                    suffixIcon: searchCtrl.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.textcolor1.withOpacity(0.5),
                        size: 20,
                      ),
                      onPressed: () {
                        searchCtrl.clear();
                        searchQuery.value = "";
                        _applySearch();
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) {
                    searchQuery.value = value.trim().toLowerCase();
                    _applySearch();
                  },
                ),
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary1,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary1.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "pb",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.65),
    );
  }

  void _applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredConversations.assignAll(conversations);
    } else {
      filteredConversations.assignAll(
        conversations.where((item) {
          final title = (item.title ?? "").toLowerCase();
          final category = (item.category ?? "").toLowerCase();
          final last = (item.lastMessage ?? "").toLowerCase();
          return title.contains(searchQuery.value) ||
              category.contains(searchQuery.value) ||
              last.contains(searchQuery.value);
        }).toList(),
      );
    }
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}
