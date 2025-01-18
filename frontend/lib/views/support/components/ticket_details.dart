import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

import '../../../constants/colors.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/dto/image_dto.dart';
import '../../../models/support_message.dart';
import '../../../models/support_ticket.dart';
import '../../../models/user.dart';
import '../../../networking/api_base_helper.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/draggable_bottomsheet.dart';
import '../../../widgets/overflowed_text_with_tooltip.dart';
import '../../profile/user_profile/user_profile_screen.dart';

class TicketDetails extends StatelessWidget {
  static const String routeName = '/ticket-details';
  final SupportTicket ticket;
  const TicketDetails({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    SupportTicket currentTicket = ticket;
    final TextEditingController messageController = TextEditingController();
    TicketPriority ticketPriority = currentTicket.priority;
    TicketStatus ticketStatus = currentTicket.status!;
    ImageDTO? attachment;
    bool saveRequired() => ticketStatus != currentTicket.status || ticketPriority != currentTicket.priority;
    return StatefulBuilder(builder: (context, setState) {
      void sendMessage(String ticketId) {
        if (messageController.text.trim().isEmpty) return;
        UserRepository.find
            .sendSupportMessage(SupportMessage(
              ticketId: ticketId,
              message: messageController.text,
              attachment: attachment,
              guestId: SharedPreferencesService.find.get(guestIdKey),
            ))
            .then((value) => setState(() => attachment = null));
        messageController.clear();
      }

      Future<void> attachToMessage() async {
        final file = await Helper.pickFiles(multiple: false);
        if (file != null) {
          attachment = ImageDTO.fromXFile(XFile.fromData(await file[0].readAsBytes(), name: file[0].name, path: file[0].path));
          setState(() {});
        }
      }

      return CustomStandardScaffold(
        backgroundColor: kNeutralColor100,
        title: 'ticket_details'.tr,
        actionButton: saveRequired()
            ? CustomButtons.icon(
                icon: const Icon(Icons.save_outlined),
                onPressed: () async {
                  final result = await UserRepository.find.updateSupportTicket(SupportTicket(
                    id: currentTicket.id,
                    category: currentTicket.category,
                    status: ticketStatus,
                    subject: currentTicket.subject,
                    description: currentTicket.description,
                    priority: ticketPriority,
                    guestId: SharedPreferencesService.find.get(guestIdKey),
                  ));
                  if (result != null) setState(() => currentTicket = result);
                },
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(Paddings.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('support_ticket'.tr, style: AppFonts.x15Bold),
              const SizedBox(height: Paddings.regular),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('opened_by'.tr, style: AppFonts.x14Bold),
                        const SizedBox(width: Paddings.regular),
                        InkWell(
                          onTap: () => Get.bottomSheet(
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                              child: UserProfileScreen(user: currentTicket.user),
                            ),
                            isScrollControlled: true,
                          ),
                          child: Buildables.userImage(providedUser: currentTicket.user, size: 40),
                        ),
                        const SizedBox(width: Paddings.small),
                        Text(currentTicket.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Regular),
                      ],
                    ),
                    const SizedBox(height: Paddings.small),
                    Text('${'subject'.tr}: ${currentTicket.subject}', style: AppFonts.x14Bold),
                    const SizedBox(height: Paddings.small),
                    Text('${'category'.tr}: ${currentTicket.category.name.tr}', style: AppFonts.x12Bold.copyWith(color: kNeutralColor)),
                    const SizedBox(height: Paddings.regular),
                    Text('${'description'.tr}: ${currentTicket.description}', style: AppFonts.x14Regular),
                    if (AuthenticationService.find.jwtUserData?.role == Role.admin) ...[
                      if (ticket.logs != null) ...[
                        buildAttachmentFile(fileName: ticket.logs!.name, label: 'logfile'.tr, type: 'log'),
                        const SizedBox(height: Paddings.regular),
                      ],
                      if (ticket.attachments != null && ticket.attachments!.isNotEmpty) ...[
                        Text('${'attachments'.tr}:', style: AppFonts.x14Regular),
                        for (var imageDto in ticket.attachments!) buildAttachmentFile(fileName: imageDto.file.name, label: '', type: imageDto.type.name),
                        const SizedBox(height: Paddings.regular),
                      ],
                    ],
                    const SizedBox(height: Paddings.regular),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(currentTicket.createdAt != null ? Helper.formatDateWithTime(currentTicket.createdAt!) : 'NA', style: AppFonts.x12Regular),
                    ),
                    const SizedBox(height: Paddings.regular),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropDownMenu(
                            items: TicketStatus.values,
                            valueFrom: (status) => status.name.tr,
                            selectedItem: ticketStatus,
                            hint: ticketStatus.name.tr,
                            dropDownWithDecoration: true,
                            buttonHeight: 45,
                            buttonWidth: double.infinity,
                            onChanged: (status) => setState(() => ticketStatus = status!),
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
                            hint: ticketPriority.name.tr,
                            onChanged: (priority) => setState(() => ticketPriority = priority!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Paddings.exceptional),
              Text('messages'.tr, style: AppFonts.x15Bold),
              const SizedBox(height: Paddings.regular),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                    child: FutureBuilder(
                      future: UserRepository.find.getTicketMessages(currentTicket.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('error_occurred'.tr));
                        } else if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                          return SizedBox(height: 300, child: Center(child: Text('no_messages'.tr)));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final ticketMessage = snapshot.data?[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(ticketMessage!.user?.name ?? 'user'.tr, style: AppFonts.x15Bold),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ticketMessage.message, style: AppFonts.x14Regular),
                                    if (ticketMessage.attachment != null) ...[
                                      buildAttachmentFile(fileName: ticketMessage.attachment!.file.name, type: ticketMessage.attachment!.type.name, label: ''),
                                      const SizedBox(height: Paddings.regular),
                                    ],
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(Helper.formatDateWithTime(currentTicket.createdAt!), style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (attachment != null) ...[
                    Row(
                      children: [
                        OverflowedTextWithTooltip(title: '${'attached_file'.tr}: ${attachment!.file.name}', style: AppFonts.x12Bold, widthPadding: 30),
                        CustomButtons.icon(
                          icon: const Icon(Icons.close, color: kErrorColor, size: 18),
                          onPressed: () => setState(() => attachment = null),
                        )
                      ],
                    ),
                    const SizedBox(height: Paddings.regular),
                  ],
                  CustomTextField(
                    fieldController: messageController,
                    outlinedBorder: true,
                    hintText: 'send_message'.tr,
                    textAlign: TextAlign.start,
                    onSubmitted: (_) => sendMessage(currentTicket.id!),
                    prefixIcon: CustomButtons.icon(
                      icon: const Icon(Icons.attach_file_rounded),
                      onPressed: attachToMessage,
                    ),
                    suffixIcon: CustomButtons.icon(
                      onPressed: () => sendMessage(currentTicket.id!),
                      icon: const Icon(Icons.send, color: kNeutralColor),
                      disabled: currentTicket.status == TicketStatus.closed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Paddings.extraLarge),
            ],
          ),
        ),
      );
    });
  }

  Widget buildAttachmentFile({required String fileName, required String type, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(top: Paddings.regular),
      child: InkWell(
        onTap: () async {
          http.Response? logContent;
          if (type == 'log') {
            logContent = await ApiBaseHelper.find.request(
              RequestType.get,
              '/public/support_attachments/${type == 'log' ? 'logs' : type == 'image' ? 'images' : 'documents'}/$fileName',
            );
          }

          Widget wrapWithScrollable({required Widget child, required bool isWrap}) => isWrap ? Scrollbar(child: SingleChildScrollView(child: child)) : child;
          return Get.bottomSheet(
              DraggableBottomsheet(
                dragHandlerPadding: 20,
                child: Material(
                  color: kNeutralColor100,
                  child: wrapWithScrollable(
                    isWrap: type == 'log' || type == 'image',
                    child: Padding(
                      padding: const EdgeInsets.all(Paddings.large).copyWith(bottom: Paddings.exceptional),
                      child: type == 'log'
                          ? Text(logContent!.body, style: AppFonts.x14Regular)
                          : type == 'image'
                              ? Image.network(ApiBaseHelper.find.getLogs(fileName, type))
                              : SizedBox(height: Get.height * 0.9, child: SfPdfViewer.network(ApiBaseHelper.find.getLogs(fileName, type))),
                    ),
                  ),
                ),
              ),
              isScrollControlled: true);
        },
        child: Text(
          label.isEmpty ? fileName : '$label: $fileName',
          style: AppFonts.x14Regular.copyWith(decoration: TextDecoration.underline, height: 1, color: kSelectedColor, decorationColor: kSelectedColor),
        ),
      ),
    );
  }
}
