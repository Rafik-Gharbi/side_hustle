import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/constants.dart';
import '../constants/sizes.dart';

enum LoadingCardEffectType { task, category, store, chat, profile }

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
  const CategoryLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => CardLoading(
          height: (Get.width - 60) / 4,
          width: (Get.width - 60) / 4,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          margin: const EdgeInsets.only(bottom: 10),
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
