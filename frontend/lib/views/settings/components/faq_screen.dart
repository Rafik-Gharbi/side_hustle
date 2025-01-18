import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom_standard_scaffold.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStandardScaffold(
      backgroundColor: kNeutralColor100,
      title: 'faq'.tr,
      body: const Column(
        children: [
          // TODO get questions and answers from backend database translated
        ],
      ),
    );
  }
}
