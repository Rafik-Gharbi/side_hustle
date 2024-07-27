import 'package:flutter/material.dart';

import '../../../constants/sizes.dart';
import '../../../services/theme/theme.dart';

class AnimatedTitle extends StatefulWidget {
  final String title;

  const AnimatedTitle({required this.title, super.key});

  @override
  AnimatedTitleState createState() => AnimatedTitleState();
}

class AnimatedTitleState extends State<AnimatedTitle> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAnimated) {
      _isAnimated = true;
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) => SlideTransition(
        position: _animation,
        child: Padding(
          padding: const EdgeInsets.only(left: 3, bottom: Paddings.small),
          child: Text(widget.title, overflow: TextOverflow.ellipsis, style: AppFonts.x18Bold),
        ),
      );
}
