import 'package:flutter/material.dart';

class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;

  const OnHover({required this.builder, super.key});

  @override
  OnHoverState createState() => OnHoverState();
}

class OnHoverState extends State<OnHover> {
  bool isHovered = false;

  void onEntered(bool isHovered) => setState(() => this.isHovered = isHovered);

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => onEntered(true),
        onExit: (_) => onEntered(false),
        child: widget.builder(isHovered),
      );
}
