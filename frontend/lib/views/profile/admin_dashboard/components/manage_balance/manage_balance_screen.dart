import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/constants.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../helpers/buildables.dart';
import '../../../../../helpers/helper.dart';
import '../../../../../models/balance_transaction.dart';
import '../../../../../services/theme/theme.dart';
import '../../../../../widgets/balance_transaction_card.dart';
import '../../../../../widgets/custom_buttons.dart';
import '../../../../../widgets/custom_scaffold_bottom_navigation.dart';
import '../../../../../widgets/hold_in_safe_area.dart';
import '../../../../../widgets/loading_request.dart';
import '../../../balance/balance_controller.dart';
import '../../../profile_screen/profile_controller.dart';
import 'manage_balance_controller.dart';

class ManageBalanceScreen extends StatelessWidget {
  static const String routeName = '/manage-balance';
  const ManageBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HoldInSafeArea(
      child: GetBuilder<ManageBalanceController>(
        autoRemove: false,
        builder: (controller) => CustomScaffoldBottomNavigation(
          appBarTitle: 'manage_balance'.tr,
          onBack: () => ProfileController.find.init(),
          body: LoadingRequest(
            isLoading: controller.isLoading,
            child: controller.balanceTransactionList.isEmpty
                ? Center(child: Text('nothing_here_yet'.tr, style: AppFonts.x14Regular))
                : ListView.builder(
                    itemCount: controller.balanceTransactionList.length,
                    itemBuilder: (context, index) {
                      final balanceTransaction = controller.balanceTransactionList[index];
                      bool highlighted = false;
                      bool isInitialized = false;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                        child: Theme(
                          data: ThemeData(dividerColor: Colors.transparent),
                          child: ClipRRect(
                            borderRadius: smallRadius,
                            child: StatefulBuilder(builder: (context, setState) {
                              if (context.mounted && !isInitialized) {
                                Future.delayed(
                                  const Duration(milliseconds: 600),
                                  () => context.mounted ? setState(() => highlighted = balanceTransaction.id == controller.highlightedBalanceTransaction?.id) : null,
                                );
                              }
                              isInitialized = true;
                              return ExpansionTile(
                                key: Key(balanceTransaction.hashCode.toString()),
                                title: buildUserCard(balanceTransaction),
                                tilePadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: Paddings.regular),
                                shape: RoundedRectangleBorder(borderRadius: smallRadius, side: BorderSide(color: kNeutralLightColor)),
                                backgroundColor: kNeutralLightOpacityColor,
                                collapsedBackgroundColor: highlighted ? kPrimaryOpacityColor : kNeutralLightOpacityColor,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Buildables.buildProfileInfoRow('email'.tr, balanceTransaction.user?.email ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow(
                                    'birthdate'.tr,
                                    balanceTransaction.user?.birthdate != null ? Helper.formatDate(balanceTransaction.user!.birthdate!) : 'not_provided'.tr,
                                  ),
                                  Buildables.lightDivider(),
                                  Buildables.buildProfileInfoRow('gender'.tr, balanceTransaction.user?.gender?.value ?? 'not_provided'.tr),
                                  Buildables.lightDivider(),
                                  const SizedBox(height: Paddings.large),
                                  Text('user_balance_transaction'.tr, style: AppFonts.x15Bold),
                                  const SizedBox(height: Paddings.regular),
                                  BalanceTransactionCard(transaction: balanceTransaction),
                                  if (balanceTransaction.description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: Paddings.regular),
                                      child: Text('${'description'.tr} ${balanceTransaction.description}', style: AppFonts.x15Bold),
                                    ),
                                  if (balanceTransaction.depositType == DepositType.installment && balanceTransaction.depositSlip?.file.path != null)
                                    Center(
                                      child: InkWell(
                                        onTap: () => showImageViewer(context, Image.network(balanceTransaction.depositSlip!.file.path).image),
                                        child: ClipRRect(
                                          borderRadius: smallRadius,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: Paddings.regular),
                                            child: Image.network(balanceTransaction.depositSlip!.file.path, height: 150, width: 150, fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    )
                                  else if (balanceTransaction.depositType == DepositType.installment)
                                    Padding(
                                      padding: const EdgeInsets.only(top: Paddings.regular),
                                      child: Text('document_not_available'.tr, style: AppFonts.x12Bold.copyWith(color: kErrorColor)),
                                    ),
                                  const SizedBox(height: Paddings.regular),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButtons.text(
                                        title: 'not_approvable'.tr,
                                        titleStyle: AppFonts.x14Regular,
                                        onPressed: () => controller.rejectBalanceRequest(balanceTransaction),
                                      ),
                                      CustomButtons.icon(
                                        icon: const Icon(Icons.phone_outlined),
                                        onPressed: () => controller.callUser(balanceTransaction.user),
                                      ),
                                      CustomButtons.elevatePrimary(
                                        title: 'approve'.tr,
                                        width: (Get.width - 120) / 2,
                                        onPressed: () => controller.acceptBalanceRequest(balanceTransaction),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: Paddings.regular),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String path, BuildContext context) {
    return InkWell(
      onTap: () => showImageViewer(context, Image.network(path).image),
      child: ClipRRect(
        borderRadius: smallRadius,
        child: Image.network(path, height: (Get.width - 100) / 2, width: (Get.width - 100) / 2, fit: BoxFit.cover),
      ),
    );
  }

  Widget buildUserCard(BalanceTransaction transaction) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Buildables.userImage(providedUser: transaction.user, size: 40),
      title: Text(transaction.user?.name ?? 'not_provided'.tr, style: AppFonts.x14Bold),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(transaction.user?.phone ?? 'not_provided'.tr, style: AppFonts.x14Regular),
          Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pin_drop_outlined, size: 14),
                const SizedBox(width: Paddings.small),
                Text(transaction.user?.governorate?.name ?? 'city'.tr, style: AppFonts.x14Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
