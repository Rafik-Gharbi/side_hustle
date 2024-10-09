import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';

class LoadingStoresEffect extends StatelessWidget {
  final RxBool isLoading;
  final Widget child;

  const LoadingStoresEffect({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? Padding(
              padding: const EdgeInsets.all(Paddings.large),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    5,
                    (index) => CardLoading(
                      height: 150,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      margin: const EdgeInsets.only(bottom: 10),
                      cardLoadingTheme: CardLoadingTheme(colorOne: kNeutralLightColor, colorTwo: kNeutralLightOpacityColor),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Paddings.regular),
                            child: CardLoading(
                              height: 100,
                              width: 100,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              margin: EdgeInsets.only(bottom: 10),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CardLoading(
                                height: 40,
                                width: 100,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              CardLoading(
                                height: 40,
                                width: 150,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : child,
    );
  }
}
