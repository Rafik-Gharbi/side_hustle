import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/shared_preferences_keys.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/buildables.dart';
import '../../../helpers/helper.dart';
import '../../../models/transaction.dart';
import '../../../services/shared_preferences.dart';
import '../../../services/theme/theme.dart';
import '../../../services/tutorials/transactions_tutorial.dart';
import '../../../widgets/custom_standard_scaffold.dart';
import '../../../widgets/hold_in_safe_area.dart';
import '../../../widgets/loading_request.dart';
import '../../../widgets/main_screen_with_bottom_navigation.dart';
import '../../../widgets/overflowed_text_with_tooltip.dart';
import 'transactions_controller.dart';

class TransactionsScreen extends StatelessWidget {
  static const String routeName = '/my-transactions';
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool hasOpenedTutorial = false.obs;
    return HoldInSafeArea(
      child: GetBuilder<TransactionsController>(
        initState: (state) => Helper.waitAndExecute(() => state.controller != null && !(state.controller?.isLoading.value ?? true), () {
          final hasFinishedChatTutorial = SharedPreferencesService.find.get(hasFinishedTransactionsTutorialKey) == 'true';
          if (!hasFinishedChatTutorial &&
              Get.currentRoute == routeName &&
              !hasOpenedTutorial.value &&
              state.controller!.transactions.isNotEmpty &&
              state.controller!.targets.isNotEmpty) {
            hasOpenedTutorial.value = true;
            MainScreenWithBottomNavigation.isOnTutorial.value = true;
            TutorialCoachMark(
              targets: state.controller!.targets,
              colorShadow: kNeutralOpacityColor,
              textSkip: 'skip'.tr,
              additionalWidget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                child: Obx(
                  () => CheckboxListTile(
                    dense: true,
                    checkColor: kNeutralColor100,
                    contentPadding: EdgeInsets.zero,
                    side: const BorderSide(color: kNeutralColor100),
                    title: Text('not_show_again'.tr, style: AppFonts.x12Regular.copyWith(color: kNeutralColor100)),
                    value: TransactionsTutorial.notShowAgain.value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) => TransactionsTutorial.notShowAgain.value = value ?? false,
                  ),
                ),
              ),
              onSkip: () {
                if (TransactionsTutorial.notShowAgain.value) {
                  SharedPreferencesService.find.add(hasFinishedTransactionsTutorialKey, 'true');
                }
                MainScreenWithBottomNavigation.isOnTutorial.value = false;
                hasOpenedTutorial.value = false;
                return true;
              },
              onFinish: () => SharedPreferencesService.find.add(hasFinishedTransactionsTutorialKey, 'true'),
            ).show(context: context);
          }
        }),
        builder: (controller) => Obx(
          () => PopScope(
            canPop: !hasOpenedTutorial.value,
            child: CustomStandardScaffold(
              backgroundColor: kNeutralColor100,
              title: 'my_transactions'.tr,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Buildables.buildAvailableCoins(key: controller.coinsOverview, onBackFromMarket: controller.init),
                    LoadingRequest(
                      isLoading: controller.isLoading,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.availableCoinPacks.isNotEmpty) ...[
                              Text('available_coin_packs'.tr, style: AppFonts.x15Bold),
                              const SizedBox(height: Paddings.regular),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    controller.availableCoinPacks.length,
                                    (index) {
                                      final pack = controller.availableCoinPacks[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: Paddings.regular),
                                        child: SizedBox(
                                          width: 300,
                                          height: 110,
                                          child: Stack(
                                            children: [
                                              // Overlay showing "used" portion with a sharp cutoff
                                              FractionallySizedBox(
                                                widthFactor: pack.available! / pack.coinPack.totalCoins,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColorWhiter.withOpacity(0.7),
                                                    borderRadius: smallRadius,
                                                  ),
                                                  child: const SizedBox(width: 300, height: 110),
                                                ),
                                              ),
                                              // Background showing total amount in neutral color
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: kNeutralLightColor.withOpacity(0.5),
                                                  border: lightBorder,
                                                  borderRadius: smallRadius,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(Paddings.regular),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(height: Paddings.regular),
                                                      Expanded(
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(child: Text(pack.coinPack.title, style: AppFonts.x16Bold)),
                                                            const SizedBox(width: Paddings.small),
                                                            if (pack.coinPack.bonus != null)
                                                              Text(
                                                                'plus_bonus'.trParams({'bonus': pack.coinPack.bonus.toString()}),
                                                                style: AppFonts.x14Bold.copyWith(color: kAccentColor),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        'pack_available_coins'.trParams(
                                                          {
                                                            'available': pack.available.toString(),
                                                            'totalCoins': pack.coinPack.totalCoins.toString(),
                                                            'usedUp': pack.available == 0 ? '(all used up)' : ''
                                                          },
                                                        ),
                                                        style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                                                      ),
                                                      const SizedBox(height: Paddings.small),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(
                                                          'expires_in_days'.trParams({
                                                            'expiration':
                                                                pack.createdAt.add(Duration(days: 30 * pack.coinPack.validMonths)).difference(DateTime.now()).inDays.toString()
                                                          }),
                                                          style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                                                        ),
                                                      ),
                                                      const SizedBox(height: Paddings.regular),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                            if (controller.transactions.isNotEmpty)
                              Theme(
                                data: ThemeData(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: Text('transactions_history'.tr, style: AppFonts.x15Bold),
                                  initiallyExpanded: true,
                                  children: List.generate(
                                    controller.transactions.length,
                                    (index) {
                                      final transaction = controller.transactions[index];
                                      final isTask = transaction.task != null;
                                      final isService = transaction.service != null;
                                      final isExpenses = transaction.type == TransactionType.proposal;
                                      final isRefunded = transaction.status == TransactionStatus.refunded;
                                      final isBuyingCoins = transaction.type == TransactionType.purchase;
                                      final isRequest = transaction.type == TransactionType.request;
                                      final isCoinPackUsage = transaction.coinPack != null;

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: ListTile(
                                          key: index == 0 ? controller.firstTransactionsKey : null,
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              OverflowedTextWithTooltip(
                                                title: isTask
                                                    ? transaction.task!.title
                                                    : isService
                                                        ? transaction.service!.name!
                                                        : transaction.type.name.tr,
                                                style: AppFonts.x14Regular,
                                              ),
                                              const SizedBox(width: Paddings.small),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${isExpenses && !isRefunded ? '-' : '+'} ${transaction.coins} ',
                                                    style: AppFonts.x14Bold.copyWith(
                                                      color: isExpenses && !isRefunded ? kErrorColor : kConfirmedColor,
                                                    ),
                                                  ),
                                                  Icon(Icons.paid_outlined, size: 18, color: isExpenses && !isRefunded ? kErrorColor : kConfirmedColor),
                                                ],
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '${'status'.tr}: ${transaction.status.name.tr}',
                                                    style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                                                  ),
                                                  Text(
                                                    Helper.formatDate(transaction.createdAt),
                                                    style: AppFonts.x12Regular.copyWith(color: kNeutralColor),
                                                  ),
                                                ],
                                              ),
                                              if (isCoinPackUsage && isExpenses)
                                                Text('${'from_coin_pack'.tr}: ${transaction.coinPack!.title}', style: AppFonts.x10Regular.copyWith(color: kNeutralColor)),
                                            ],
                                          ),
                                          leading: Tooltip(
                                            message: transaction.type.name.tr,
                                            child: isRequest
                                                ? const Icon(Icons.task_outlined)
                                                : isTask || isService
                                                    ? const Icon(Icons.work_outline_outlined)
                                                    : isBuyingCoins
                                                        ? const Icon(Icons.shopping_cart_outlined)
                                                        : const Icon(Icons.account_balance_outlined),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              Center(child: Text('no_transactions_yet'.tr, style: AppFonts.x14Regular)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Paddings.large),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
