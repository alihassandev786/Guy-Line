import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/legalcontentcontroller.dart';
import 'legalcontentscreen.dart';

class Privacypolicy extends StatefulWidget {
  const Privacypolicy({super.key});

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  final controller = Get.isRegistered<LegalContentController>()
      ? Get.find<LegalContentController>()
      : Get.put(LegalContentController());

  @override
  Widget build(BuildContext context) {
    return LegalContentScreen(
      title: "Privacy Policy",
      paragraphs: controller.privacyPolicyParagraphs,
    );
  }
}