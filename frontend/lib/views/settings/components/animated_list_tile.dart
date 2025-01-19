import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../services/theme/theme.dart';

class AnimatedListTile extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? widget;
  final Decoration? tileDecoration;
  final void Function()? onTap;

  const AnimatedListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.trailing,
    this.widget,
    this.titleStyle,
    this.tileDecoration,
  });

  @override
  AnimatedListTileState createState() => AnimatedListTileState();
}

class AnimatedListTileState extends State<AnimatedListTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isAnimated = false;
  bool disabled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    disabled = widget.onTap == null;
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Paddings.small),
        child: SlideTransition(
          position: _animation,
          child: DecoratedBox(
            decoration: widget.tileDecoration ?? BoxDecoration(borderRadius: smallRadius, color: kNeutralLightOpacityColor),
            child: Opacity(
              opacity: disabled ? 0.3 : 1,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                minVerticalPadding: 0,
                leading: widget.leading,
                trailing: widget.trailing,
                title: widget.widget ??
                    Text(
                      widget.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: widget.titleStyle ?? AppFonts.x16Bold,
                    ),
                subtitle: widget.subtitle != null ? Text(widget.subtitle!, style: AppFonts.x14Regular) : null,
                onTap: () => widget.onTap?.call(),
              ),
            ),
          ),
        ),
      );
}
