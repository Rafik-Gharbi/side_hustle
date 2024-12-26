import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../controllers/main_app_controller.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/extensions/date_time_extension.dart';
import '../../../helpers/helper.dart';
import '../../../models/chat.dart';
import '../../../models/contract.dart';
import '../../../services/authentication_service.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/message_bubble.dart';
import '../chat_controller.dart';
import 'contract_dialog.dart';

class BuildChatMessages extends StatelessWidget {
  const BuildChatMessages({super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GetBuilder<ChatController>(
          builder: (controller) => StreamBuilder<List<ChatModel>?>(
            stream: controller.streamSocket.socketStream,
            initialData: controller.discussionHistory,
            builder: (BuildContext context, AsyncSnapshot<List<ChatModel>?> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    if (controller.isLoadingMoreChat) Buildables.buildLoadingWidget(height: 80),
                    Expanded(
                      child: ListView.builder(
                        controller: controller.chatScrollController,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final msg = snapshot.data![index];
                          final isSearch = controller.searchMessagesController.text.isNotEmpty;
                          final contract = msg.message.startsWith('{') && msg.message.endsWith('}') ? Contract.fromJson(jsonDecode(msg.message)) : null;
                          return Column(
                            children: [
                              if (isSearch && index == snapshot.data!.length - 1 && !controller.endLoadBefore)
                                Center(
                                  child: CustomButtons.text(
                                    onPressed: () => controller.getBeforeAfterMessages(snapshot.data![snapshot.data!.length - 1].id, true),
                                    title: 'load_more'.tr,
                                    titleStyle: AppFonts.x12Regular,
                                  ),
                                ),
                              // Add chat message date
                              if (index == (snapshot.data?.length ?? 0) - 1 ||
                                  index < (snapshot.data?.length ?? 0) - 1 &&
                                      !snapshot.data![index + 1].createdAt.isSameDate(contract != null ? contract.createdAt : msg.createdAt))
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: Paddings.small),
                                    child: Text(
                                      DateFormat.MMMMEEEEd().format(contract != null ? contract.createdAt : msg.createdAt),
                                      style: AppFonts.x12Bold.copyWith(color: kNeutralColor),
                                    ),
                                  ),
                                ),
                              if (contract != null)
                                buildContract(contract, controller)
                              else
                                MessageBubble(
                                  date: msg.createdAt,
                                  searchText: controller.searchMessagesController.text,
                                  msgText: msg.message,
                                  loggedUser: AuthenticationService.find.jwtUserData!.id != msg.recieverId,
                                ),
                              if (isSearch && index == 0 && !controller.endLoadAfter)
                                Center(
                                  child: CustomButtons.text(
                                    onPressed: () => controller.getBeforeAfterMessages(snapshot.data![0].id, false),
                                    title: 'load_more'.tr,
                                    titleStyle: AppFonts.x12Regular,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Get.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('nothing_here_yet'.tr, style: AppFonts.x14Regular),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );

  Column buildContract(Contract contract, ChatController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Paddings.small),
          child: Center(
            child: OpenContainer(
              closedElevation: 0,
              transitionDuration: const Duration(milliseconds: 600),
              openBuilder: (_, __) => ContractDialog(
                contract: contract,
                onRejectContract: () {
                  controller.messageController.text = 'reject_contract_msg'.tr;
                  controller.sendMessage();
                },
                onSignContract: () => controller.signContract(contract),
              ),
              closedBuilder: (_, openContainer) => ListTile(
                onTap: openContainer,
                contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                shape: RoundedRectangleBorder(borderRadius: smallRadius, side: const BorderSide(color: kNeutralLightColor)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('new_contract'.tr, style: AppFonts.x15Bold),
                    if (contract.isSigned && contract.isPayed)
                      Tooltip(
                        margin: const EdgeInsets.symmetric(horizontal: Paddings.large),
                        message: 'contract_signed_payed_msg'.tr,
                        child: Image.asset(Assets.signedContract, width: 30, height: 30, color: kConfirmedColor),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (contract.task != null) ...[
                      Text('${'task'.tr}: ${contract.task!.title}', style: AppFonts.x12Regular),
                      Text('${'description'.tr}: ${contract.task!.description}', style: AppFonts.x12Regular),
                      Text('${'expected_delivrables'.tr}: ${contract.task!.delivrables ?? 'not_provided'.tr}', style: AppFonts.x12Regular),
                      Text('${'price'.tr}: ${Helper.formatAmount(contract.finalPrice)} ${MainAppController.find.currency.value}', style: AppFonts.x12Regular),
                      Text('${'due_date'.tr}: ${Helper.formatDate(contract.dueDate!)}', style: AppFonts.x12Regular),
                    ] else if (contract.service != null) ...[
                      Text('${'service'.tr}: ${contract.service!.name}', style: AppFonts.x12Regular),
                      Text('${'description'.tr}: ${contract.service!.description}', style: AppFonts.x12Regular),
                      Text('${'expected_delivrables'.tr}: ${contract.service!.included ?? 'not_provided'.tr}', style: AppFonts.x12Regular),
                      Text('${'price'.tr}: ${Helper.formatAmount(contract.finalPrice)} ${MainAppController.find.currency.value}', style: AppFonts.x12Regular),
                      Text('${'due_date'.tr}: ${Helper.formatDate(contract.dueDate!)}', style: AppFonts.x12Regular),
                    ],
                  ],
                ),
                leading: const Icon(Icons.assignment_outlined, color: kNeutralColor),
              ),
            ),
          ),
        ),
        if (!contract.isSigned)
          Text('${contract.provider?.name ?? 'provider'.tr} ${'sign_contract_msg'.tr}', style: AppFonts.x14Regular.copyWith(color: kErrorColor))
        else if (!contract.isPayed)
          Text('${contract.seeker?.name ?? 'seeker'.tr} ${'pay_contract_msg'.tr}', style: AppFonts.x14Regular.copyWith(color: kErrorColor)),
      ],
    );
  }
}
