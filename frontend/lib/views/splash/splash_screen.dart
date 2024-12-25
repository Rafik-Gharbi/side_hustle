import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../constants/shared_preferences_keys.dart';
import '../../helpers/helper.dart';
import '../../services/shared_preferences.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(Assets.dootifyLogoAnimation)
      ..initialize().then((_) {
        setState(() {}); // Refresh the widget once the video is loaded
        _controller.play();
      })
      ..setLooping(false)
      ..addListener(() {
        if (_controller.value.isInitialized && !_controller.value.isPlaying && _controller.value.position >= _controller.value.duration) {
          // Navigate to the next screen after the video ends
          Helper.waitAndExecute(
            () => SharedPreferencesService.find.isReady.value,
            () {
              final isFirstTime = SharedPreferencesService.find.get(isFirstTimeKey) == null;
              return isFirstTime ? Get.offAndToNamed(OnboardingScreen.routeName) : Get.offAndToNamed(HomeScreen.routeName);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralColor100,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(), // Show a loader until the video is ready
      ),
    );
  }
}
