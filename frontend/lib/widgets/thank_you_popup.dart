import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/helper.dart';
import '../services/theme/theme.dart';

class ThankYouPopup extends StatefulWidget {
  const ThankYouPopup({super.key});

  @override
  ThankYouPopupState createState() => ThankYouPopupState();
}

class ThankYouPopupState extends State<ThankYouPopup> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late AnimationController _heartBeatController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _rotationAnimation = Tween<double>(begin: -0.01, end: 0.01).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    // Heartbeat Animation Controller
    _heartBeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1 second for a heartbeat cycle
    )..repeat(reverse: true); // Repeat the heartbeat
    // Color Animation for Heartbeat
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.pinkAccent,
    ).animate(CurvedAnimation(parent: _heartBeatController, curve: Curves.easeInOut));

    _controller.repeat(reverse: true); // Continuous scaling and rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    _heartBeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Helper.goBack(),
        child: Center(
          child: Stack(
            children: [
              // Semi-transparent background
              Container(
                color: Colors.black.withOpacity(0.5),
                height: double.infinity,
                width: double.infinity,
              ),
              // Dialog Content
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: RotationTransition(
                    turns: _rotationAnimation,
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Heart Icon with heartbeat effect
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Icon(
                                  Icons.favorite,
                                  color: _colorAnimation.value,
                                  size: 80, // Increased size for emphasis
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: Paddings.large),
                          // Thank You Message
                          Text('thank_you'.tr, style: AppFonts.x24Bold.copyWith(fontSize: 28, color: kPrimaryColor)),
                          const SizedBox(height: Paddings.large),
                          // Motivational Message
                          Text('feedback_thanks_msg'.tr, textAlign: TextAlign.center, style: AppFonts.x16Regular),
                          const SizedBox(height: Paddings.exceptional),
                          // Close Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              backgroundColor: kPrimaryColor, // Button color
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text('close'.tr, style: AppFonts.x16Regular.copyWith(color: kNeutralColor100)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Floating Animations (Confetti)
              const Positioned.fill(child: ConfettiAnimation()),
            ],
          ),
        ),
      ),
    );
  }
}

// Confetti Animation Widget
class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({super.key});

  @override
  ConfettiAnimationState createState() => ConfettiAnimationState();
}

class ConfettiAnimationState extends State<ConfettiAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(microseconds: 1), vsync: this)..repeat();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => CustomPaint(painter: ConfettiPainter(_controller.value)),
      );
}

// ConfettiPainter to draw the floating confetti
class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()
      ..color = Colors.primaries[random.nextInt(Colors.primaries.length)]
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 10; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * animationValue;
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint every frame for animation
  }
}
