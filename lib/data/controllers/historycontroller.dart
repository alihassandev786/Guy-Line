import 'package:get/get.dart';

class HistoryItem {
  final String title;
  final String description;
  final String tag;
  final String timeAgo;

  HistoryItem({
    required this.title,
    required this.description,
    required this.tag,
    required this.timeAgo,
  });
}

class HistorySection {
  final String? sectionTitle;
  final List<HistoryItem> items;

  HistorySection({
    this.sectionTitle,
    required this.items,
  });
}

class HistoryController extends GetxController {
  final RxList<HistorySection> historySections = <HistorySection>[
    HistorySection(
      sectionTitle: null, // Today / Top items without section header
      items: [
        HistoryItem(
          title: "Moving House",
          description: "Discussing logistics for the move next weekend,",
          tag: "Logistics",
          timeAgo: "2h ago",
        ),
        HistoryItem(
          title: "Work Stress",
          description: "Discussing logistics for the move next weekend,",
          tag: "Venting",
          timeAgo: "5h ago",
        ),
      ],
    ),
    HistorySection(
      sectionTitle: "Yesterday",
      items: [
        HistoryItem(
          title: "Fitness Routine",
          description: "Discussing logistics for the move next weekend,",
          tag: "Health",
          timeAgo: "",
        ),
        HistoryItem(
          title: "Relationship Advice",
          description: "Discussing logistics for the move next weekend,",
          tag: "Advice",
          timeAgo: "",
        ),
      ],
    ),
    HistorySection(
      sectionTitle: "Previous 7 Days",
      items: [
        HistoryItem(
          title: "Moving House",
          description: "Discussing logistics for the move next weekend,",
          tag: "Logistics",
          timeAgo: "2h ago",
        ),
      ],
    ),
  ].obs;

  void onSearchTap() {
    // TODO: Search feature action
  }

  void onItemTap(HistoryItem item) {
    // TODO: Open History detail screen
  }
}