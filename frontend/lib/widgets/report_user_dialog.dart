import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/form_validators.dart';
import '../models/dto/report_dto.dart';
import '../models/enum/report_reasons.dart';
import '../models/service.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../repositories/params_repository.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_text_field.dart';

class ReportUserDialog extends StatefulWidget {
  final User user;
  final Task? task;
  final Service? service;

  const ReportUserDialog({super.key, required this.user, this.task, this.service});

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController explanationController = TextEditingController();
  ReportReasons? _selectedReportReasons;

  @override
  Widget build(BuildContext context) {
    final isMobile = GetPlatform.isMobile || Get.width < kMobileMaxWidth;
    return isMobile
        ? Padding(
            padding: const EdgeInsets.only(top: Paddings.exceptional * 3),
            child: Material(
              color: kNeutralColor100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: buildContent(isMobile),
            ),
          )
        : AlertDialog(
            backgroundColor: kNeutralColor100,
            surfaceTintColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: buildContent(isMobile),
          );
  }

  SizedBox buildContent(bool isMobile) => SizedBox(
        width: isMobile ? Get.width : 400,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? Paddings.extraLarge : Paddings.large),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('report'.tr, style: AppFonts.x18Bold),
                      CustomButtons.icon(icon: const Icon(Icons.close), onPressed: Get.back),
                    ],
                  ),
                  const SizedBox(height: Paddings.regular),
                  Text('why_reporting'.tr, style: AppFonts.x14Bold),
                  const SizedBox(height: Paddings.regular),
                  Text('reporting_msg'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  const SizedBox(height: Paddings.large),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      ReportReasons.values.length,
                      (index) => RadioListTile<ReportReasons>(
                        title: Text(ReportReasons.values[index].value.tr, style: AppFonts.x14Regular),
                        value: ReportReasons.values[index],
                        groupValue: _selectedReportReasons,
                        onChanged: (value) => setState(() => _selectedReportReasons = value),
                      ),
                    ),
                  ),
                  const SizedBox(height: Paddings.large),
                  Text('reason'.tr, style: AppFonts.x14Bold),
                  const SizedBox(height: Paddings.regular),
                  Text('help_us_understand'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                  const SizedBox(height: Paddings.extraLarge),
                  CustomTextField(
                    hintText: 'write_an_explanation'.tr,
                    fieldController: explanationController,
                    isTextArea: true,
                    outlinedBorder: true,
                    validator: _selectedReportReasons == ReportReasons.other ? FormValidators.notEmptyOrNullValidator : null,
                  ),
                  const SizedBox(height: Paddings.exceptional),
                  CustomButtons.elevatePrimary(
                    title: 'submit_report'.tr,
                    width: isMobile ? Get.width : 400,
                    disabled: _selectedReportReasons == null,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        ParamsRepository.find.reportUser(
                          ReportDTO(
                            user: widget.user,
                            task: widget.task,
                            service: widget.service,
                            reasons: _selectedReportReasons!,
                            explanation: explanationController.text,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: Paddings.exceptional),
                ],
              ),
            ),
          ),
        ),
      );
}
