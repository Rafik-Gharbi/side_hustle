import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/form_validators.dart';
import '../../../helpers/helper.dart';
import '../../../models/support_ticket.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/logger_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class AddSupportTicket extends StatelessWidget {
  const AddSupportTicket({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    TicketPriority? ticketPriority = TicketPriority.low;
    TicketCategory? ticketCategory;
    List<XFile>? attachments;
    bool hasError = false;
    bool attachLogs = true;
    RxBool isLoading = false.obs;
    return StatefulBuilder(builder: (context, setState) {
      Future<void> uploadAttachments() async {
        final files = await Helper.pickFiles();
        if (files != null) {
          if (attachments == null) {
            attachments = files;
          } else {
            attachments!.addAll(files.where((element) => !attachments!.map((e) => e.name).contains(element.name)));
          }
          setState(() {});
        }
      }

      void removeAttachments(XFile xFile) {
        attachments?.remove(xFile);
        setState(() {});
      }

      double attachmentSize = (Get.width - 50) / 3;
      if ((attachments?.length ?? 0) > 3) attachmentSize = attachmentSize * 0.9;

      double containerHeight = 560;
      if (hasError) containerHeight += 60;
      if (attachments != null && attachments!.isNotEmpty) containerHeight += attachmentSize;
      if (ticketCategory == TicketCategory.technicalIssue) containerHeight += 50;

      return AnimatedContainer(
        height: containerHeight,
        duration: Durations.medium1,
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: kNeutralColor100,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: Paddings.regular),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtons.icon(
                          icon: const Icon(Icons.close),
                          onPressed: () => Helper.goBack(),
                        ),
                        Text('add_new_ticket'.tr, style: AppFonts.x16Bold),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Buildables.lightDivider(color: kNeutralColor.withOpacity(0.5)),
                  Padding(
                    padding: const EdgeInsets.all(Paddings.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Paddings.large),
                        CustomTextField(
                          hintText: 'subject'.tr,
                          outlinedBorder: true,
                          isOptional: false,
                          fieldController: subjectController,
                          validator: FormValidators.notEmptyOrNullValidator,
                        ),
                        const SizedBox(height: Paddings.regular),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomDropDownMenu(
                                items: TicketCategory.values.where((element) => element != TicketCategory.profileDeletion).toList(),
                                valueFrom: (category) => category.name.tr,
                                selectedItem: ticketCategory,
                                hint: ticketCategory?.name.tr ?? 'select_option'.tr,
                                dropDownWithDecoration: true,
                                buttonHeight: 45,
                                isRequired: true,
                                buttonWidth: double.infinity,
                                validator: FormValidators.notNullObjectValidator,
                                onChanged: (category) => setState(() => ticketCategory = category),
                              ),
                            ),
                            const SizedBox(width: Paddings.regular),
                            Expanded(
                              child: CustomDropDownMenu(
                                items: TicketPriority.values,
                                valueFrom: (priority) => priority.name.tr,
                                selectedItem: ticketPriority,
                                dropDownWithDecoration: true,
                                buttonHeight: 45,
                                buttonWidth: double.infinity,
                                hint: ticketPriority?.name.tr ?? 'select_option'.tr,
                                onChanged: (priority) => setState(() => ticketPriority = priority),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Paddings.regular),
                        CustomTextField(
                          hintText: 'description'.tr,
                          fieldController: descriptionController,
                          isTextArea: true,
                          isOptional: false,
                          outlinedBorder: true,
                          validator: FormValidators.notEmptyOrNullValidator,
                        ),
                        const SizedBox(height: Paddings.regular),
                        if (ticketCategory == TicketCategory.technicalIssue) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            minVerticalPadding: 0,
                            dense: true,
                            title: Text('attach_logs'.tr, style: AppFonts.x14Regular),
                            leading: Checkbox(
                              checkColor: kNeutralColor100,
                              value: attachLogs,
                              onChanged: (value) => setState(() => attachLogs = !attachLogs),
                            ),
                          ),
                          const SizedBox(height: Paddings.regular),
                        ],
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Text('${'attachments'.tr}: ', style: AppFonts.x14Regular),
                              CustomButtons.text(
                                title: 'attach_files_pictures'.tr,
                                titleStyle: AppFonts.x12Regular,
                                onPressed: () => uploadAttachments(),
                              ),
                            ],
                          ),
                          leading: const Icon(Icons.attach_file_outlined, color: kNeutralColor),
                        ),
                        if (attachments != null)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                attachments!.length,
                                (index) {
                                  final xFile = attachments![index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: index < attachments!.length - 1 ? Paddings.regular : 0),
                                    child: Stack(
                                      children: [
                                        DecoratedBox(
                                          decoration: BoxDecoration(borderRadius: smallRadius, border: regularBorder),
                                          child: SizedBox(
                                            width: attachmentSize,
                                            height: attachmentSize,
                                            child: Center(
                                              child: Helper.isImage(xFile.name.toLowerCase())
                                                  ? ClipRRect(borderRadius: smallRadius, child: Image.file(File(xFile.path), fit: BoxFit.cover))
                                                  : Padding(
                                                      padding: const EdgeInsets.all(Paddings.small),
                                                      child: Text(
                                                        xFile.name,
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor: kNeutralOpacityColor,
                                            child: CustomButtons.icon(
                                              icon: const Icon(Icons.close, size: 14, color: kNeutralColor100),
                                              onPressed: () => removeAttachments(xFile),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: Paddings.exceptional),
                        Center(
                          child: CustomButtons.elevatePrimary(
                            title: 'submit'.tr,
                            loading: isLoading,
                            width: 250,
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                isLoading.value = true;
                                hasError = false;
                                final logFile = await LoggerService.find.getLogFile();
                                UserRepository.find
                                    .submitSupportTicket(
                                  SupportTicket(
                                    guestId: Helper.getOrCreateGuestId(),
                                    category: ticketCategory!,
                                    subject: subjectController.text,
                                    description: descriptionController.text,
                                    priority: ticketPriority!,
                                    logs: attachLogs ? logFile : null,
                                  ),
                                  attachments,
                                )
                                    .then((value) {
                                  isLoading.value = false;
                                  if (value) Get.back(result: true);
                                });
                              } else {
                                setState(() => hasError = true);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: Paddings.exceptional),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
