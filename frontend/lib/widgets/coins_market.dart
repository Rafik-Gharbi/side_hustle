import 'package:firebase_analytics/firebase_analytics.dart';
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
import '../services/theme/theme.dart';
import 'custom_buttons.dart';
import 'custom_standard_scaffold.dart';

class CoinsMarketController extends GetxController {
  List<CoinPack> coinPacks = [];
  RxBool isLoading = false.obs;

  CoinsMarketController() {
    _init();
  }

  Future<void> _init() async {
    coinPacks = (await ParamsRepository.find.getCoinsPack()) ?? [];
    update();
  }

  void purchaseCoins(CoinPack pack) => Helper.openConfirmationDialog(
      content: 'buy_coins_costs_msg'.trParams({'totalCoins': pack.totalCoins.toString(), 'price': pack.price.toString()}),
      onConfirm: () {
        isLoading.value = true;
        Future.delayed(const Duration(milliseconds: 100)).then(
          (value) => Get.bottomSheet(
            isScrollControlled: true,
            Buildables.buildPaymentOptionsBottomsheet(
              totalPrice: pack.price.toDouble(),
              coinPackId: pack.id,
              onSuccessPayment: () {
                TransactionRepository.find.buyCoinPack(pack).then((value) {
                  if (value) update();
                  FirebaseAnalytics.instance.logEvent(
                    name: 'purchase_coins',
                    parameters: {
                      'pack_name': pack.title,
                      'price': pack.price,
                    },
                  );
                });
              },
            ),
          ).then((_) => isLoading.value = false),
        );
      });
}

class CoinsMarket extends GetWidget<CoinsMarketController> {
  static const String routeName = '/coins-market';
  const CoinsMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinsMarketController>(
      initState: (state) => FirebaseAnalytics.instance.logScreenView(screenName: 'CoinMarket'),
      builder: (controller) => CustomStandardScaffold(
        backgroundColor: kNeutralColor100,
        title: 'coin_shop'.tr,
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
        onTap: () => controller.purchaseCoins(pack),
        child: SizedBox(
          width: double.infinity,
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
                      if (pack.bonus != null) const SizedBox(height: Paddings.extraLarge * 2),
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
                            loading: controller.isLoading,
                            width: 200,
                            height: 40,
                            title: 'buy_for_price'.trParams({'price': pack.price.toString()}),
                            titleStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor100),
                            onPressed: () => controller.purchaseCoins(pack),
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
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                          child: Center(child: Text('save_percentage'.trParams({'percentage': pack.save.toString()}), style: AppFonts.x12Bold.copyWith(color: kNeutralColor100))),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
