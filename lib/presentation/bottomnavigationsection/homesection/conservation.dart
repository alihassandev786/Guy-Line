import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guyline/core/theme/appcolors.dart';
import 'package:guyline/presentation/Widgets/Backbutton.dart';
import 'package:guyline/presentation/Widgets/MediaqueryHelperfile.dart';
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
    final double horizontalPadding = AppSize.widthPercent(0.05);

    return PopScope(
        canPop: false,   // default pop band
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.goBack();   // system back → Home
        },
        child: AppBackground(
          padding: EdgeInsets.zero,
          child: SafeArea(
            child: Column(
          children: [
            SizedBox(height: AppSize.heightPercent(0.015)),

            /// HEADER — back + logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(
                      onTap: () => controller.goBack(),   // ← Home pe le jaye
                    ),
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    height: AppSize.height * 0.045,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSize.heightPercent(0.02)),

            /// TITLE / DATE CHIP — only when title is set (category topic)
            Center(
              child: Obx(() {
                final title = controller.chatTitle.value.trim();
                if (title.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.widthPercent(0.05),
                    vertical: AppSize.heightPercent(0.01),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "pb",
                          fontSize: AppSize.widthPercent(0.035),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.chatDate.value.isNotEmpty)
                        Text(
                          controller.chatDate.value,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontFamily: "pr",
                            fontSize: AppSize.widthPercent(0.024),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: AppSize.heightPercent(0.02)),

            /// MESSAGE LIST + AI typing indicator
            Expanded(
              child: Obx(() {
                final msgs = controller.messages;
                final typing = controller.isAiTyping.value;
                final count = msgs.length + (typing ? 1 : 0);

                return ListView.builder(
                  controller: controller.chatScrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSize.heightPercent(0.01),
                  ),
                  itemCount: count,
                  itemBuilder: (context, index) {
                    if (typing && index == msgs.length) {
                      return const _TypingIndicator();
                    }
                    return _ChatBubble(message: msgs[index]);
                  },
                );
              }),
            ),

            /// SUGGESTION CHIPS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: List.generate(
                  controller.suggestionChips.length,
                      (index) {
                    final chip = controller.suggestionChips[index];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 6,
                          right: index == controller.suggestionChips.length - 1
                              ? 0
                              : 6,
                        ),
                        child: _SuggestionChip(
                          label: chip,
                          onTap: () => controller.onSuggestionTap(chip),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: AppSize.heightPercent(0.018)),

            /// INPUT BAR — send button WITHOUT spinner (AI typing is enough)
            Container(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSize.heightPercent(0.012),
                horizontalPadding,
                AppSize.heightPercent(0.02),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSize.height * 0.062,
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
                              controller: controller.messageInputController,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "pr",
                                fontSize: AppSize.widthPercent(0.037),
                              ),
                              cursorColor: AppColors.primary1,
                              onSubmitted: (_) => controller.sendMessage(),
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
                  Obx(() {
                    final busy = controller.isSendingMessage.value;
                    return GestureDetector(
                      onTap: busy ? null : controller.sendMessage,
                      child: Opacity(
                        opacity: busy ? 0.55 : 1.0,
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
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

/// AI typing bubble — animated three dots
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.heightPercent(0.022)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.widthPercent(0.05),
            vertical: AppSize.heightPercent(0.016),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.09),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(22),
            ),
          ),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final t = (_ctrl.value + i * 0.2) % 1.0;
                  // bounce opacity 0.3 → 1 → 0.3
                  final opacity = t < 0.5
                      ? 0.3 + (t * 1.4)
                      : 1.0 - ((t - 0.5) * 1.4);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.widthPercent(0.008),
                    ),
                    child: Opacity(
                      opacity: opacity.clamp(0.3, 1.0),
                      child: Container(
                        width: AppSize.widthPercent(0.022),
                        height: AppSize.widthPercent(0.022),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

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

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSize.height * 0.045,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.primary1.withOpacity(0.55),
            width: 1.2,
          ),
          color: AppColors.primary2.withOpacity(0.2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.background,
            fontFamily: "pr",
            fontSize: AppSize.widthPercent(0.030),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
