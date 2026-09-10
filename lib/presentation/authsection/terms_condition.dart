import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/legalcontentcontroller.dart';
import 'legalcontentscreen.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  final controller = Get.isRegistered<LegalContentController>()
      ? Get.find<LegalContentController>()
      : Get.put(LegalContentController());

  @override
  Widget build(BuildContext context) {
    return LegalContentScreen(
      title: "Terms & Conditions",
      paragraphs: controller.termsConditionParagraphs,
    );
  }
}