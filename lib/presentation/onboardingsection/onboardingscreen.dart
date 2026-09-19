import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/widgets/CustomTile.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

import '../../core/routes/approutes.dart';
import '../../data/services/onboardingservice.dart';
import '../../data/services/sessionmanager.dart';
import '../Widgets/AppNavigator.dart';
import '../Widgets/Button.dart';
import '../Widgets/appbackground.dart';
import '../Widgets/snackbar.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  final PageController _pageController = PageController();
  final OnboardingService _onboardingService = OnboardingService();

  int _currentPage = 0;
  int _selectedThinkingStyle = 0;
  bool _isLoading = false;

  /// Selected interests (multi-select) from Page 2
  final Set<String> _selectedInterests = {};

  /// Maps thinking-style list index -> API value expected by backend
  final List<String> _thinkingStyleValues = [
    "listen",
    "straightforward",
    "challenge",
    "decide",
  ];

  Future<void> _onNext() async {
    // Page 0 = intro (koi selection nahi) → freely next
    // Page 1 = interests → kam se kam 1 select zaroori
    if (_currentPage == 1 && _selectedInterests.isEmpty) {
      SnackbarService.error("Please select at least one interest");
      return;
    }
    // Page 2 = thinking style (default 0 selected hai, lekin safety)
    if (_currentPage == 2 && _selectedThinkingStyle < 0) {
      SnackbarService.error("Please select a thinking style");

      return;
    }

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    // Last page — submit
    await _submitOnboarding();
  }
  Future<void> _submitOnboarding() async {
    final currentUser = SessionManager.instance.getUser();

    // If no logged-in user yet (e.g. onboarding shown before signup),
    // skip the API call gracefully and just proceed.
    if (currentUser == null) {
      print("🟡 [Onboardingscreen] No user in session, skipping onboarding API call");
      AppNavigator.pushAndClear(AppRoutes.welcome);
      return;
    }

    if (_selectedInterests.isEmpty) {
      SnackbarService.error("Please select at least one interest");
      return;
    }

    setState(() => _isLoading = true);

    final String thinkingStyleValue = _thinkingStyleValues[_selectedThinkingStyle];

    print("🟡 [Onboardingscreen] Submitting onboarding for user: ${currentUser.id}");
    print("🟡 [Onboardingscreen] Interests: $_selectedInterests");
    print("🟡 [Onboardingscreen] Thinking Style: $thinkingStyleValue");

    final result = await _onboardingService.completeOnboarding(
      userId: currentUser.id,
      interests: _selectedInterests.toList(),
      thinkingStyle: thinkingStyleValue,
    );

    setState(() => _isLoading = false);

    if (result.success && result.user != null) {
      print("✅ [Onboardingscreen] Onboarding completed: ${result.user!.username}");

      // Update session with latest user data (includes onboarding_completed = true)
      await SessionManager.instance.saveUser(result.user!);
      SnackbarService.success(result.message);

      AppNavigator.pushAndClear(AppRoutes.welcome);
    } else {
      print("❌ [Onboardingscreen] Onboarding failed: ${result.message}");
      SnackbarService.error(result.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.05);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          /// PAGE VIEW CONTENT
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // swipe band
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPageOne(horizontalPadding),
                _buildPageTwo(horizontalPadding),
                _buildPageThree(horizontalPadding),
              ],
            ),
          ),

          /// BOTTOM CONTINUE BUTTON
          Positioned(
            bottom: AppSize.heightPercent(0.06),
            left: horizontalPadding,
            right: horizontalPadding,
            child: CustomButton(
              title: _isLoading ? "Please wait..." : "Continue",
              onTap: _isLoading ? () {} : _onNext,
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// PAGE 1
  /// --------------------------------------------------------------------------
  Widget _buildPageOne(double horizontalPadding) {
    const double imageTopPosition = 0.0;
    final double imageHeight = AppSize.heightPercent(0.40);

    return Column(
      children: [
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: imageTopPosition),
            child: Image.asset(
              "assets/images/onb1.png",
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SizedBox(height: AppSize.heightPercent(0.09)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Text(
                "Whatever’s On\nYour Mind!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pb",
                  fontSize: AppSize.widthPercent(0.07),
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              SizedBox(height: AppSize.heightPercent(0.017)),
              Text(
                "A private place to talk it through.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor2,
                  fontFamily: "pr",
                  fontSize: AppSize.widthPercent(0.0395),
                ),
              ),
              SizedBox(height: AppSize.heightPercent(0.015)),
              _buildPageIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  /// --------------------------------------------------------------------------
  /// PAGE 2: Topics Grid (now selectable / multi-select)
  /// --------------------------------------------------------------------------
  Widget _buildPageTwo(double horizontalPadding) {
    final List<Map<String, dynamic>> topics = [
      {"title": "Fatherhood", "icon": Icons.home_outlined},
      {"title": "Career", "icon": Icons.work_outline},
      {"title": "Relationships", "icon": Icons.people_outline},
      {"title": "Wealth", "icon": Icons.account_balance_wallet_outlined},
      {"title": "Goals", "icon": Icons.flag_outlined},
      {"title": "Decisions", "icon": Icons.alt_route_outlined},
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: MediaQuery.of(context).padding.top + AppSize.heightPercent(0.04),
        bottom: AppSize.heightPercent(0.1),
      ),
      child: Column(
        children: [
          Text(
            "Talk Through\nReal Life!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textcolor1,
              fontFamily: "pb",
              fontSize: AppSize.widthPercent(0.075),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: AppSize.heightPercent(0.015)),
          Text(
            "Relationships • Work • Money • Fatherhood •\nGoals • Decisions",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textcolor2,
              fontFamily: "pr",
              fontSize: AppSize.widthPercent(0.037),
              height: 1.3,
            ),
          ),
          SizedBox(height: AppSize.heightPercent(0.02)),
          _buildPageIndicator(),
          SizedBox(height: AppSize.heightPercent(0.04)),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topics.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSize.widthPercent(0.04),
                mainAxisSpacing: AppSize.heightPercent(0.025),
                childAspectRatio: 1.7,
              ),
              itemBuilder: (context, index) {
                final item = topics[index];
                final String title = item["title"] as String;
                final bool isSelected = _selectedInterests.contains(title);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(title);
                      } else {
                        _selectedInterests.add(title);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary1.withOpacity(0.2)
                          : AppColors.primary2.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSize.height * 0.025),
                      border: Border.all(
                        color: isSelected ? AppColors.primary1 : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item["icon"] as IconData,
                          color: AppColors.primary1,
                          size: AppSize.widthPercent(0.07),
                        ),
                        SizedBox(height: AppSize.heightPercent(0.01)),
                        Text(
                          title,
                          style: TextStyle(
                            color: AppColors.textcolor2,
                            fontFamily: "pm",
                            fontSize: AppSize.widthPercent(0.035),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// PAGE 3: Thinking Style Selection
  /// --------------------------------------------------------------------------
  Widget _buildPageThree(double horizontalPadding) {
    final List<Map<String, String>> styles = [
      {"title": "Listen", "subtitle": "Act as a sounding board"},
      {"title": "Be Straightforward", "subtitle": "Direct and efficient"},
      {"title": "Challenge My Thinking", "subtitle": "Push boundaries, offer alternative"},
      {"title": "Help Me Make Decisions", "subtitle": "Structured analysis and pros/cons"},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
          top: MediaQuery.of(context).padding.top + AppSize.heightPercent(0.04),
          bottom: AppSize.heightPercent(0.12),
        ),
        child: Column(
          children: [
            Text(
              "How to Show\nGuy Line?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textcolor1,
                fontFamily: "pb",
                fontSize: AppSize.widthPercent(0.075),
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SizedBox(height: AppSize.heightPercent(0.015)),
            Text(
              "Pick your thinking style. Change later.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textcolor2,
                fontFamily: "pr",
                fontSize: AppSize.widthPercent(0.039),
              ),
            ),
            SizedBox(height: AppSize.heightPercent(0.025)),
            _buildPageIndicator(),
            SizedBox(height: AppSize.heightPercent(0.05)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: styles.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSize.heightPercent(0.012)),
              itemBuilder: (context, index) {
                final isSelected = _selectedThinkingStyle == index;
                return CustomTile(
                  height: AppSize.height * 0.09,
                  title: styles[index]["title"]!,
                  titleColor: AppColors.textcolor1,
                  subtitleColor: AppColors.textcolor2,
                  subtitle: styles[index]["subtitle"]!,
                  backgroundColor: AppColors.primary2.withOpacity(0.1),
                  borderRadius: AppSize.height * 0.025,
                  onTap: () {
                    setState(() {
                      _selectedThinkingStyle = index;
                    });
                  },
                  leading: Container(
                    height: AppSize.widthPercent(0.1),
                    width: AppSize.widthPercent(0.1),
                    decoration: BoxDecoration(
                      color: AppColors.primary1.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.graphic_eq,
                      color: AppColors.primary1,
                      size: 20,
                    ),
                  ),
                  trailing: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary1,
                        width: 2,
                      ),
                      color: isSelected
                          ? const Color(0xFFC49A45)
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.black,
                    )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// CUSTOM PAGE INDICATOR
  /// --------------------------------------------------------------------------
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 4,
          width: _currentPage == index ? 18 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary1 : Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}