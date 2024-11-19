import 'package:flutter/material.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../../services/theme/theme.dart';

class AnimatedVerticalTextSwitcher extends StatefulWidget {
  final List<String> texts;
  final Duration duration;

  const AnimatedVerticalTextSwitcher({
    super.key,
    required this.texts,
    this.duration = const Duration(seconds: 4),
  });

  @override
  AnimatedVerticalTextSwitcherState createState() => AnimatedVerticalTextSwitcherState();
}

class AnimatedVerticalTextSwitcherState extends State<AnimatedVerticalTextSwitcher> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)..repeat(reverse: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoSwitch());
  }

  void _startAutoSwitch() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() => _currentIndex = (_currentIndex + 1) % widget.texts.length);
        _startAutoSwitch();
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
    return Padding(
      padding: const EdgeInsets.only(top: Paddings.small),
      child: SizedBox(
        height: 40,
        child: AnimatedSwitcher(
          switchOutCurve: Curves.fastOutSlowIn,
          switchInCurve: Curves.bounceIn,
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
            child: Text(
              widget.texts[_currentIndex],
              softWrap: true,
              textAlign: TextAlign.center,
              key: ValueKey<String>(widget.texts[_currentIndex]),
              style: AppFonts.x14Bold.copyWith(color: kAccentColor),
            ),
          ),
        ),
      ),
    );
  }
}
