import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../constants/colors.dart';
import '../../../repositories/params_repository.dart';
import '../../../widgets/custom_standard_scaffold.dart';

class TermsConditionScreen extends StatelessWidget {
  static const String routeName = '/terms-conditions';
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStandardScaffold(
      backgroundColor: kNeutralColor100,
      title: 'terms_condition'.tr,
      body: FutureBuilder<File?>(
        future: ParamsRepository.find.getTermsCondition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error_occurred'.tr));
          } else if (!snapshot.hasData) {
            return Center(child: Text('no_file_available'.tr));
          } else {
            return SfPdfViewer.file(snapshot.data!, pageSpacing: 1);
          }
        },
      ),
    );
  }
}
