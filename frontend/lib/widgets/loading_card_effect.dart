import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';

enum LoadingCardEffectType { task, category, store, chat, profile, categoryBottomSheet }

class LoadingCardEffect extends StatelessWidget {
  final RxBool isLoading;
  final Widget child;
  final LoadingCardEffectType type;

  const LoadingCardEffect({
    super.key,
    required this.isLoading,
    required this.child,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingEffect;
    switch (type) {
      case LoadingCardEffectType.task:
        loadingEffect = const TaskLoadingEffect();
        break;
      case LoadingCardEffectType.category:
        loadingEffect = const CategoryLoadingEffect();
        break;
      case LoadingCardEffectType.categoryBottomSheet:
        loadingEffect = const CategoryLoadingEffect(isBottomSheet: true);
        break;
      case LoadingCardEffectType.store:
        loadingEffect = const StoreLoadingEffect();
        break;
      case LoadingCardEffectType.chat:
        loadingEffect = const ChatLoadingEffect();
        break;
      case LoadingCardEffectType.profile:
        loadingEffect = const ProfileLoadingEffect();
        break;
      default:
        loadingEffect = const CircularProgressIndicator();
    }
    return Obx(() => isLoading.value ? loadingEffect : child);
  }
}

class ChatLoadingEffect extends StatelessWidget {
  const ChatLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Paddings.exceptional),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          10,
          (index) => CardLoading(
            height: 50,
            animationDuration: Duration(milliseconds: 500 + (index * 50)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            margin: const EdgeInsets.only(bottom: 10),
          ),
        ),
      ),
    );
  }
}

class TaskLoadingEffect extends StatelessWidget {
  const TaskLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        3,
        (index) => const CardLoading(
          height: 100,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          margin: EdgeInsets.only(bottom: 10),
        ),
      ),
    );
  }
}

class CategoryLoadingEffect extends StatelessWidget {
  final bool isBottomSheet;
  const CategoryLoadingEffect({super.key, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        isBottomSheet ? 3 : 1,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: isBottomSheet ? Paddings.regular : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              isBottomSheet ? 3 : 4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                child: Stack(
                  children: [
                    if (!isBottomSheet)
                      Positioned.fill(
                        child: CardLoading(
                          height: (Get.width - 100) / 4,
                          width: (Get.width - 100) / 4,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 10),
                          cardLoadingTheme: CardLoadingTheme(colorOne: kNeutralLightColor, colorTwo: kNeutralLightOpacityColor),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(isBottomSheet ? 0 : Paddings.regular),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CardLoading(
                            height: isBottomSheet ? (Get.width - 100) / 6 : (Get.width - 100) / 7,
                            width: isBottomSheet ? (Get.width - 100) / 6 : (Get.width - 100) / 7,
                            borderRadius: circularRadius,
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                          const SizedBox(height: Paddings.small),
                          CardLoading(
                            height: 20,
                            width: isBottomSheet ? (Get.width - 100) / 3 : (Get.width - 100) / 5,
                            borderRadius: smallRadius,
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                        ],
                      ),
                    ),
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

class StoreLoadingEffect extends StatelessWidget {
  const StoreLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class ProfileLoadingEffect extends StatelessWidget {
  const ProfileLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Paddings.large),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Paddings.exceptional),
              child: CardLoading(
                height: 100,
                width: 100,
                borderRadius: circularRadius,
              ),
            ),
            CardLoading(
              height: 20,
              width: 150,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 5),
            ),
            CardLoading(
              height: 15,
              width: 80,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
            ),
            CardLoading(
              height: 20,
              width: 100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
            ),
            CardLoading(
              height: 20,
              width: 120,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 30),
            ),
            ...List.generate(
              4,
              (index) => CardLoading(
                height: 40,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              6,
              (index) => CardLoading(
                height: 40,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 50).copyWith(bottom: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
