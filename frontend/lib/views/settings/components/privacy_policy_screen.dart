import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../constants/colors.dart';
import '../../../repositories/params_repository.dart';
import '../../../widgets/custom_standard_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String routeName = '/privacy-policy';
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStandardScaffold(
      backgroundColor: kNeutralColor100,
      title: 'privacy_policy'.tr,
      body: FutureBuilder<File?>(
        future: ParamsRepository.find.getPrivacyPolicy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error_occurred'.tr));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No privacy policy available'));
          } else {
            return SfPdfViewer.file(snapshot.data!, pageSpacing: 1);
          }
        },
      ),
    );
  }
}
