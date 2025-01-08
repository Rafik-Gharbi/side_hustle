import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/assets.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../../services/shared_preferences.dart';
import '../../widgets/custom_scaffold_bottom_navigation.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _zoomInAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _bounceOutAnimation;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _zoomInAnimation = Tween<double>(begin: 0.5, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.2)),
    );
    _breathingAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: 5.0),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.1), weight: 5.0),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(1.0), weight: 5.0),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 20.0),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)));

    _bounceOutAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 20.0), weight: 20.0),
        TweenSequenceItem<double>(tween: ConstantTween<double>(20.0), weight: 5.0),
        TweenSequenceItem<double>(tween: Tween<double>(begin: 20.0, end: -200.0), weight: 75.0),
      ],
    ).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)),
    );
    _controller.forward();
    // Navigate to the next screen after animation ends
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Helper.waitAndExecute(
          () => SharedPreferencesService.find.isReady.value,
          () {
            final isFirstTime = SharedPreferencesService.find.get(isFirstTimeKey) == null;
            return isFirstTime ? Get.offAndToNamed(OnboardingScreen.routeName) : Get.offAndToNamed(CustomScaffoldBottomNavigation.routeName);
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _bounceOutAnimation.value),
              child: Transform.scale(
                scale: _controller.value <= 0.2 ? _zoomInAnimation.value : _breathingAnimation.value,
                child: Opacity(
                  opacity: _fadeOutAnimation.value,
                  child: Image.asset(Assets.dootifyIconLogo, width: 150, height: 150),
                ),
              ),
            ),
          ),
        ),
      );
}
