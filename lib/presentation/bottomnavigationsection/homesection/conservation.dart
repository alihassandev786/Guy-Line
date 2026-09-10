import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/widgets/MediaqueryHelperfile.dart';
import 'package:guyline/presentation/Widgets/appbackground.dart';

import '../../../data/controllers/conservationcontroller.dart';

class Conservation extends StatefulWidget {
  const Conservation({super.key});

  @override
  State<Conservation> createState() => _ConservationState();
}

class _ConservationState extends State<Conservation> {
  final controller = Get.isRegistered<ConversationController>()
      ? Get.find<ConversationController>()
      : Get.put(ConversationController());

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = AppSize.widthPercent(0.055);

    return AppBackground(
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSize.heightPercent(0.02)),

            /// ---------------------------------------------------------
            /// 1. HEADER — back button (top row) + centered title/date
            ///    chip BELOW it (separate row, not aligned with back btn)
            /// ---------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Back button — apni alag row mein, top-left
                  const CustomBackButton(),

                  SizedBox(height: AppSize.heightPercent(0.015)),

                  /// Title/date chip — ab back button ke neeche,
                  /// poori width ke horizontally center mein
                  Center(
                    child: Obx(
                          () => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.widthPercent(0.06),
                          vertical: AppSize.heightPercent(0.012),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.chatTitle.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pb",
                                fontSize: AppSize.widthPercent(0.04),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              controller.chatDate.value,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.028),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSize.heightPercent(0.02)),

            /// ---------------------------------------------------------
            /// 2. MESSAGE LIST
            /// ---------------------------------------------------------
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  controller: controller.chatScrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSize.heightPercent(0.01),
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _ChatBubble(message: message);
                  },
                ),
              ),
            ),

            /// ---------------------------------------------------------
            /// 3. INPUT BAR
            /// ---------------------------------------------------------
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.height*0.015,vertical: AppSize.height*0.017),
              decoration: BoxDecoration(
                color: AppColors.primary2.withOpacity(0.1)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.widthPercent(0.04),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageInputController,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.037),
                              ),
                              cursorColor: AppColors.primary1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Message Guy Line...",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontFamily: "pr",
                                  fontSize: AppSize.widthPercent(0.037),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.onEmojiTap,
                            child: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: AppSize.widthPercent(0.058),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.widthPercent(0.03)),
                  GestureDetector(
                    onTap: controller.sendMessage,
                    child: Container(
                      height: AppSize.widthPercent(0.13),
                      width: AppSize.widthPercent(0.13),
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
                        size: AppSize.widthPercent(0.055),
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

/// -----------------------------------------------------------------------
/// CHAT BUBBLE — aligns left/right based on sender, timestamp underneath
/// -----------------------------------------------------------------------
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isSender = message.isSender;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.heightPercent(0.022)),
      child: Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
            isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: AppSize.widthPercent(0.75),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.widthPercent(0.045),
                vertical: AppSize.heightPercent(0.016),
              ),
              decoration: BoxDecoration(
                color: isSender
                    ? AppColors.primary1.withOpacity(0.28)
                    : Colors.white.withOpacity(0.09),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(isSender ? 22 : 4),
                  bottomRight: Radius.circular(isSender ? 4 : 22),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "pr",
                  fontSize: AppSize.widthPercent(0.037),
                  height: 1.35,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSize.heightPercent(0.006)),
          Text(
            message.time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontFamily: "pr",
              fontSize: AppSize.widthPercent(0.028),
            ),
          ),
        ],
      ),
    );
  }
}