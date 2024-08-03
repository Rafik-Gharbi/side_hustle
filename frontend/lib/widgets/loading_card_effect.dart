import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingCardEffect extends StatelessWidget {
  final RxBool isLoading;
  final Widget child;
  final bool isRowCards;

  const LoadingCardEffect({
    super.key,
    required this.isLoading,
    required this.child,
    this.isRowCards = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? isRowCards
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 4; i++)
                      CardLoading(
                        height: (Get.width - 60) / 4,
                        width: (Get.width - 60) / 4,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                  ],
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardLoading(
                      height: 100,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    CardLoading(
                      height: 100,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    CardLoading(
                      height: 100,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                  ],
                )
          : child,
    );
  }
}
