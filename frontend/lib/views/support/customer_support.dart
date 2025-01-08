import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper.dart';
import '../../models/support_ticket.dart';
import '../../repositories/user_repository.dart';
import '../../services/theme/theme.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_standard_scaffold.dart';
import '../../widgets/overflowed_text_with_tooltip.dart';
import 'components/add_support_ticket.dart';
import 'components/ticket_details.dart';

class CustomerSupport extends StatelessWidget {
  static const String routeName = '/customer-support';
  const CustomerSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomStandardScaffold(
      backgroundColor: kNeutralColor100,
      title: 'support_system'.tr,
      body: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Paddings.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Paddings.extraLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildButton(
                            icon: Icons.chat_outlined,
                            title: 'support_chat'.tr,
                            onTap: () => Helper.snackBar(message: 'feature_not_available_yet'.tr),
                          ),
                          const SizedBox(width: Paddings.large),
                          buildButton(
                            icon: Icons.add,
                            title: 'open_ticket'.tr,
                            onTap: () => Get.bottomSheet(const AddSupportTicket(), isScrollControlled: true)
                                .then((value) => value != null && value is bool && value ? Future.delayed(Durations.medium4, () => setState(() {})) : null),
                          ),
                        ],
                      ),
                      const SizedBox(height: Paddings.exceptional),
                      Text('my_tickets'.tr, style: AppFonts.x16Bold),
                      const SizedBox(height: Paddings.small),
                      FutureBuilder(
                        future: UserRepository.find.getUserSupportTickets(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('error_occurred'.tr));
                          } else if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
                            return SizedBox(height: 300, child: Center(child: Text('no_tickets_yet'.tr)));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                final ticket = snapshot.data?[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Row(
                                    children: [
                                      OverflowedTextWithTooltip(title: ticket!.subject, style: AppFonts.x15Bold),
                                      const SizedBox(width: Paddings.regular),
                                      Text(ticket.status!.name.tr, style: AppFonts.x14Regular),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${'priority'.tr}: ${ticket.priority.name.tr}', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                      Text('${'created_at'.tr}: ${Helper.formatDateWithTime(ticket.createdAt!)}', style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                                    ],
                                  ),
                                  leading: Icon(resolveTicketCategoryIcon(ticket)),
                                  onTap: () => Get.toNamed(TicketDetails.routeName, arguments: ticket)?.then((value) => setState(() {})),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )),
    );
  }

  Widget buildButton({required IconData icon, required String title, required void Function() onTap}) {
    return CustomButtons.icon(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: kPrimaryOpacityColor.withOpacity(0.4),
          borderRadius: regularRadius,
          border: Border.all(color: kPrimaryColor, width: 0.8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Paddings.extraLarge, horizontal: Paddings.exceptional),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kBlackColor),
              const SizedBox(height: Paddings.small),
              Text(title, style: AppFonts.x14Bold),
            ],
          ),
        ),
      ),
    );
  }

  IconData? resolveTicketCategoryIcon(SupportTicket ticket) {
    switch (ticket.category) {
      case TicketCategory.profileDeletion:
        return Icons.delete_forever_outlined;
      case TicketCategory.paymentIssue:
        return Icons.payment_outlined;
      case TicketCategory.technicalIssue:
        return Icons.report_problem_outlined;
      default:
        return Icons.support_outlined;
    }
  }
}
