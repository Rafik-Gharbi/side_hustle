import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../../services/shared_preferences.dart';
import '../../widgets/main_screen_with_bottom_navigation.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _finalController;
  late AnimationController _breathingController;
  late Animation<double> _zoomInAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _bounceOutAnimation;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    // Intro animation controller
    _introController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _zoomInAnimation = Tween<double>(begin: 0.5, end: 1.1).animate(CurvedAnimation(parent: _introController, curve: Curves.easeInOut));
    // Breathing animation controller
    _breathingController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _breathingAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: 5.0),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.1), weight: 5.0),
      ],
    ).animate(CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut));
    // Ending animation
    _finalController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _bounceOutAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 20.0), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(20.0), weight: 5.0),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 20.0, end: -200.0), weight: 75.0),
      ],
    ).animate(CurvedAnimation(parent: _finalController, curve: Curves.easeInOut));
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _finalController, curve: Curves.easeInOut));

    _introController.forward().whenComplete(() {
      _breathingController.repeat();
      int elapsedMilliseconds = 0;
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        elapsedMilliseconds += 100;
        // Check if the authentication service is ready
        Helper.waitAndExecute(() => SharedPreferencesService.find.isReady.value && _breathingAnimation.value == 1 && elapsedMilliseconds >= 1000, () {
          timer.cancel();
          _breathingController.stop();
          _finalController.forward().whenComplete(
            () {
              final isFirstTime = SharedPreferencesService.find.get(isFirstTimeKey) == null;
              Get.offAndToNamed(isFirstTime ? OnboardingScreen.routeName : MainScreenWithBottomNavigation.routeName);
            },
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _breathingController.dispose();
    _finalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: kNeutralColor100,
        body: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_introController, _breathingController, _finalController]),
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _bounceOutAnimation.value),
              child: Transform.scale(
                scale: _introController.isAnimating
                    ? _zoomInAnimation.value
                    : _breathingController.isAnimating
                        ? _breathingAnimation.value
                        : 1.0,
                child: Opacity(
                  opacity: _finalController.isAnimating ? _fadeOutAnimation.value : 1.0,
                  child: Image.asset(Assets.dootifyIconLogo, width: 150, height: 150),
                ),
              ),
            ),
          ),
        ),
      );
}
