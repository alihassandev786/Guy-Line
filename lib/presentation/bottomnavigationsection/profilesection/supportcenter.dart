import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/routes/approutes.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/Textfield.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';

class Supportcenter extends StatefulWidget {
  const Supportcenter({super.key});

  @override
  State<Supportcenter> createState() => _SupportcenterState();
}

class _SupportcenterState extends State<Supportcenter> {
  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);
    final searchController = TextEditingController();

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSize.heightPercent(0.015),
              ),
              child: Row(
                children: [
                  const CustomBackButton(),
                  SizedBox(width: AppSize.widthPercent(0.04)),
                  Text(
                    "Support Center",
                    style: TextStyle(
                      color: AppColors.textcolor1,
                      fontFamily: "pb",
                      fontSize: AppSize.widthPercent(0.055),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppSize.heightPercent(0.06)),

                    /// ================= LOGO =================
                    Image.asset(
                      "assets/images/logo.png",
                      height: AppSize.heightPercent(0.11),
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: AppSize.heightPercent(0.06)),

                    /// ================= TITLE =================
                    Text(
                      "How Can We Help You?",
                      style: TextStyle(
                        color: AppColors.textcolor1,
                        fontFamily: "pb",
                        fontSize: AppSize.widthPercent(0.048),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.05)),

                    /// ================= SEARCH BAR =================
                    CustomTextField(
                      controller: searchController,
                      hintText: "Search what kind of help you need..",
                      hintTextSize: AppSize.height*0.014,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textcolor2,
                        size: AppSize.widthPercent(0.055),
                      ),
                      fillColor: Colors.white.withOpacity(0.08),
                      borderColor: Colors.transparent,
                      focusedBorderColor: AppColors.primary1.withOpacity(0.5),
                    ),

                    SizedBox(height: AppSize.heightPercent(0.05)),

                    /// ================= OPTIONS =================
                    _SupportTile(
                      icon: Icons.phone_rounded,
                      title: "Contact Us",
                      onTap: () {
                        // TODO: Contact Us screen
                      },
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _SupportTile(
                      icon: Icons.description_outlined,
                      title: "Terms & Conditions",
                      onTap: () {
                        Get.toNamed(AppRoutes.termsandcondition);
                      },
                    ),
                    SizedBox(height: AppSize.heightPercent(0.01)),
                    _SupportTile(
                      icon: Icons.shield_outlined,
                      title: "Privacy Policy",
                      onTap: () {
                        Get.toNamed(AppRoutes.privacypolicy);
                      },
                    ),

                    SizedBox(height: AppSize.heightPercent(0.05)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// Support Tile Widget
/// ===============================================================
class _SupportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SupportTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.widthPercent(0.04),
          vertical: AppSize.heightPercent(0.013),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSize.height*0.02),

        ),
        child: Row(
          children: [
            /// Icon Circle
            Container(
              height: AppSize.widthPercent(0.11),
              width: AppSize.widthPercent(0.11),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary1.withOpacity(0.18),
              ),
              child: Icon(
                icon,
                color: AppColors.primary1,
                size: AppSize.widthPercent(0.05),
              ),
            ),

            SizedBox(width: AppSize.widthPercent(0.035)),

            /// Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textcolor1,
                  fontFamily: "pb",
                  fontSize: AppSize.widthPercent(0.038),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary1,
              size: AppSize.widthPercent(0.04),
            ),
          ],
        ),
      ),
    );
  }
}












// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:guyline/core/routes/approutes.dart';
// import 'package:guyline/core/theme/appcolors.dart';
// import 'package:guyline/data/controllers/supportcontroller.dart';
// import 'package:guyline/presentation/Widgets/Backbutton.dart';
// import 'package:guyline/presentation/Widgets/Button.dart';
// import 'package:guyline/presentation/Widgets/appbackground.dart';
// import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
//
// class Supportcenter extends StatefulWidget {
//   const Supportcenter({super.key});
//
//   @override
//   State<Supportcenter> createState() => _SupportcenterState();
// }
//
// class _SupportcenterState extends State<Supportcenter> {
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.isRegistered<SupportController>()
//         ? Get.find<SupportController>()
//         : Get.put(SupportController());
//
//     final double horizontalPadding = AppSize.widthPercent(0.055);
//
//     return AppBackground(
//       padding: EdgeInsets.zero,
//       child: SafeArea(
//         child: Column(
//           children: [
//             /// ================= HEADER =================
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: horizontalPadding,
//                 vertical: AppSize.heightPercent(0.015),
//               ),
//               child: Row(
//                 children: [
//                   const CustomBackButton(),
//                   SizedBox(width: AppSize.widthPercent(0.04)),
//                   Text(
//                     "Support Center",
//                     style: TextStyle(
//                       color: AppColors.textcolor1,
//                       fontFamily: "pb",
//                       fontSize: AppSize.widthPercent(0.055),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: AppSize.heightPercent(0.04)),
//
//                     /// ================= LOGO =================
//                     Center(
//                       child: Image.asset(
//                         "assets/images/logo.png",
//                         height: AppSize.heightPercent(0.1),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.04)),
//
//                     /// ================= TITLE =================
//                     Center(
//                       child: Text(
//                         "How Can We Help You?",
//                         style: TextStyle(
//                           color: AppColors.textcolor1,
//                           fontFamily: "pb",
//                           fontSize: AppSize.widthPercent(0.048),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.012)),
//                     Center(
//                       child: Text(
//                         "Send us a message and our team will respond soon.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: AppColors.textcolor2.withOpacity(0.85),
//                           fontFamily: "pr",
//                           fontSize: AppSize.widthPercent(0.032),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.04)),
//
//                     /// ================= SUBJECT (optional) =================
//                     Text(
//                       "Subject (optional)",
//                       style: TextStyle(
//                         color: AppColors.textcolor1.withOpacity(0.9),
//                         fontFamily: "pr",
//                         fontSize: AppSize.widthPercent(0.032),
//                       ),
//                     ),
//                     SizedBox(height: AppSize.heightPercent(0.01)),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.07),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.08),
//                         ),
//                       ),
//                       child: TextField(
//                         controller: controller.subjectController,
//                         style: TextStyle(
//                           color: AppColors.textcolor1,
//                           fontFamily: "pr",
//                           fontSize: AppSize.widthPercent(0.036),
//                         ),
//                         cursorColor: AppColors.primary1,
//                         decoration: InputDecoration(
//                           hintText: "e.g. Billing issue, Bug report...",
//                           hintStyle: TextStyle(
//                             color: AppColors.textcolor2.withOpacity(0.5),
//                             fontFamily: "pr",
//                             fontSize: AppSize.widthPercent(0.033),
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: AppSize.widthPercent(0.04),
//                             vertical: AppSize.heightPercent(0.018),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.025)),
//
//                     /// ================= MESSAGE =================
//                     Text(
//                       "Your Message",
//                       style: TextStyle(
//                         color: AppColors.textcolor1.withOpacity(0.9),
//                         fontFamily: "pr",
//                         fontSize: AppSize.widthPercent(0.032),
//                       ),
//                     ),
//                     SizedBox(height: AppSize.heightPercent(0.01)),
//                     Container(
//                       width: double.infinity,
//                       height: AppSize.heightPercent(0.18),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: AppSize.widthPercent(0.04),
//                         vertical: AppSize.heightPercent(0.015),
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.07),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.08),
//                         ),
//                       ),
//                       child: TextField(
//                         controller: controller.messageController,
//                         maxLines: 8,
//                         style: TextStyle(
//                           color: AppColors.textcolor1,
//                           fontFamily: "pr",
//                           fontSize: AppSize.widthPercent(0.036),
//                         ),
//                         cursorColor: AppColors.primary1,
//                         decoration: InputDecoration(
//                           hintText: "Describe your issue or question in detail...",
//                           hintStyle: TextStyle(
//                             color: AppColors.textcolor2.withOpacity(0.5),
//                             fontFamily: "pr",
//                             fontSize: AppSize.widthPercent(0.033),
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.zero,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.03)),
//
//                     /// ================= SUBMIT BUTTON =================
//                     Obx(
//                           () => CustomButton(
//                         title: controller.isSubmitting.value
//                             ? "Sending..."
//                             : "Submit Request",
//                         onTap: controller.isSubmitting.value
//                             ? null
//                             : controller.submitRequest,
//                       ),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.04)),
//
//                     /// ================= QUICK LINKS =================
//                     Text(
//                       "More Help",
//                       style: TextStyle(
//                         color: AppColors.textcolor1,
//                         fontFamily: "pb",
//                         fontSize: AppSize.widthPercent(0.038),
//                       ),
//                     ),
//                     SizedBox(height: AppSize.heightPercent(0.015)),
//
//                     _SupportTile(
//                       icon: Icons.description_outlined,
//                       title: "Terms & Conditions",
//                       onTap: () => Get.toNamed(AppRoutes.termsandcondition),
//                     ),
//                     SizedBox(height: AppSize.heightPercent(0.01)),
//                     _SupportTile(
//                       icon: Icons.shield_outlined,
//                       title: "Privacy Policy",
//                       onTap: () => Get.toNamed(AppRoutes.privacypolicy),
//                     ),
//
//                     SizedBox(height: AppSize.heightPercent(0.05)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SupportTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;
//
//   const _SupportTile({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: AppSize.widthPercent(0.04),
//           vertical: AppSize.heightPercent(0.013),
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.primary2.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(AppSize.height * 0.02),
//         ),
//         child: Row(
//           children: [
//             Container(
//               height: AppSize.widthPercent(0.11),
//               width: AppSize.widthPercent(0.11),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.primary1.withOpacity(0.18),
//               ),
//               child: Icon(
//                 icon,
//                 color: AppColors.primary1,
//                 size: AppSize.widthPercent(0.05),
//               ),
//             ),
//             SizedBox(width: AppSize.widthPercent(0.035)),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: AppColors.textcolor1,
//                   fontFamily: "pb",
//                   fontSize: AppSize.widthPercent(0.038),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               color: AppColors.primary1,
//               size: AppSize.widthPercent(0.04),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
