import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/bottomnavigationsection/homesection/homescreen.dart';
import 'package:guyline/presentation/bottomnavigationsection/historysection/historyscreen.dart';
import 'package:guyline/presentation/bottomnavigationsection/profilesection/profilescreen.dart';

import '../../data/controllers/historycontroller.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0;

  /// Teeno tabs ki screens — index ke sath match honi chahiye
  final List<Widget> _screens = const [
    Homescreen(),
    HistoryScreen(),
    Profilescreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    // History tab open hone pe data refresh karo
    if (index == 1) {
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().refresh();
      } else {
        Get.put(HistoryController()); // pehli dafa
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppSize.heightPercent(0.022),
        horizontal: AppSize.widthPercent(0.04),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(icon: Icons.home_rounded, label: "Home", index: 0),
            _navItem(icon: Icons.history_rounded, label: "History", index: 1),
            _navItem(icon: Icons.person_rounded, label: "Profile", index: 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(index),
      child: Icon(
        icon,
        size: AppSize.widthPercent(0.065),
        color: isSelected
            ? AppColors.primary1
            : AppColors.textcolor1.withOpacity(0.5),
      ),
    );
  }
}