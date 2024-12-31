import 'package:flutter/material.dart';

import '../../../constants/assets.dart';

class LogoAnimation extends StatefulWidget {
  const LogoAnimation({super.key});

  @override
  LogoAnimationState createState() => LogoAnimationState();
}

class LogoAnimationState extends State<LogoAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _translateAnimation = Tween<double>(begin: -200.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _translateAnimation.value),
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        ),
        child: Image.asset(Assets.dootifyLogo, width: 250),
      ),
    );
  }
}
