import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';
import '../helpers/buildables.dart';
import '../helpers/helper.dart';
import '../models/coin_pack.dart';
import '../repositories/params_repository.dart';
import '../repositories/transaction_repository.dart';
import '../services/authentication_service.dart';
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_scaffold_bottom_navigation.dart';

class CoinsMarketController extends GetxController {
  List<CoinPack> coinPacks = [];

  CoinsMarketController() {
    _init();
  }

  Future<void> _init() async {
    coinPacks = (await ParamsRepository.find.getCoinsPack()) ?? [];
    update();
  }
}

class CoinsMarket extends GetWidget<CoinsMarketController> {
  static const String routeName = '/coins-market';
  const CoinsMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinsMarketController>(
      builder: (controller) => CustomScaffoldBottomNavigation(
        appBarTitle: 'coin_shop'.tr,
        body: Column(
          children: [
            Buildables.buildAvailableCoins(withBuyButton: false),
            _buildShopItems(),
          ],
        ),
      ),
    );
  }

  // Coin pack list view
  Widget _buildShopItems() => GetBuilder<CoinsMarketController>(
        builder: (controller) => Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(Paddings.large),
            itemCount: controller.coinPacks.length,
            itemBuilder: (context, index) {
              final pack = controller.coinPacks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: Paddings.regular),
                child: _buildCoinPackCard(pack),
              );
            },
          ),
        ),
      );

  // Coin pack card widget
  Widget _buildCoinPackCard(CoinPack pack) => InkWell(
        onTap: () => _purchaseCoins(pack),
        child: SizedBox(
          width: double.infinity,
          height: pack.bonus != null && pack.bonusMsg != null ? 180 : 140,
          child: DecoratedBox(
            decoration: BoxDecoration(color: kNeutralLightOpacityColor, border: lightBorder, borderRadius: smallRadius),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Paddings.regular),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pack.bonus != null) const SizedBox(height: Paddings.exceptional),
                      Row(
                        children: [
                          Text(pack.title, style: AppFonts.x16Bold),
                          const SizedBox(width: Paddings.small),
                          if (pack.bonus != null) Text('plus_bonus'.trParams({'bonus': pack.bonus.toString()}), style: AppFonts.x14Bold.copyWith(color: kAccentColor)),
                        ],
                      ),
                      Text(pack.description, style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                      const SizedBox(height: Paddings.small),
                      if (pack.bonusMsg != null) Text(pack.bonusMsg!, style: AppFonts.x12Bold.copyWith(color: kAccentColor)),
                      const SizedBox(height: Paddings.large),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('valid_for_x_days'.trParams({'days': (pack.validMonths * 30).toString()}), style: AppFonts.x12Regular.copyWith(color: kNeutralColor)),
                          CustomButtons.elevatePrimary(
                            width: 200,
                            height: 40,
                            title: 'buy_for_price'.trParams({'price': pack.price.toString()}),
                            titleStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor100),
                            onPressed: () => _purchaseCoins(pack),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (pack.save != null)
                  Positioned(
                    top: 10,
                    right: 0,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(color: kAccentColor, borderRadius: BorderRadius.horizontal(left: Radius.circular(10))),
                      child: SizedBox(
                        width: 80,
                        height: 30,
                        child: Center(child: Text('save_percentage'.trParams({'percentage': pack.save.toString()}), style: AppFonts.x12Bold.copyWith(color: kNeutralColor100))),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  void _purchaseCoins(CoinPack pack) => Helper.openConfirmationDialog(
      title: 'buy_coins_costs_msg'.trParams({'totalCoins': pack.totalCoins.toString(), 'price': pack.price.toString()}),
      onConfirm: () {
        Future.delayed(const Duration(milliseconds: 100)).then(
          (value) => Get.bottomSheet(
            isScrollControlled: true,
            Buildables.buildPaymentOptionsBottomsheet(
              onBankCardPressed: () {
                Helper.goBack();
                Helper.snackBar(message: 'bank_card_not_supported_yet'.tr); // TODO add bank card payment
              },
              onBalancePressed: () async {
                Helper.goBack();
                if ((AuthenticationService.find.jwtUserData?.balance ?? 0) < pack.price) {
                  Helper.snackBar(message: 'not_enough_balance'.tr);
                  return;
                }
                TransactionRepository.find.buyCoinPack(pack).then((value) {
                  if (value) controller.update();
                });
              },
            ),
          ),
        );
      });
}
