import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../services/theme/theme.dart';
import '../../../widgets/custom_button_with_overlay.dart';

class MenuOptionItem {
  final IconData icon;
  final String label;
  final void Function() onTap;

  MenuOptionItem({required this.icon, required this.label, required this.onTap});
}

class CircularButtonWithMenu extends StatefulWidget {
  final List<MenuOptionItem> menuItems;
  const CircularButtonWithMenu({super.key, required this.menuItems});

  @override
  CircularButtonWithMenuState createState() => CircularButtonWithMenuState();
}

class CircularButtonWithMenuState extends State<CircularButtonWithMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconRotation;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _iconRotation = Tween<double>(begin: 0.0, end: 0.75).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (isMenuOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return CustomButtonWithOverlay(
      onOpenOverlay: _toggleMenu,
      onCloseOverlay: _toggleMenu,
      offset: const Offset(0, 45),
      button: Center(
        child: CircleAvatar(
          radius: 12,
          backgroundColor: kNeutralColor,
          child: AnimatedBuilder(
            animation: _iconRotation,
            builder: (context, child) => Transform.rotate(
              angle: _iconRotation.value * 1.67 * 3.14159265359, // Full rotation (2π)
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ),
      menu: SizedBox(
        height: widget.menuItems.length * 60,
        width: 210,
        child: Column(
          children: List.generate(
            widget.menuItems.length,
            (index) => ListTile(
              leading: Icon(widget.menuItems[index].icon),
              title: Text(widget.menuItems[index].label, style: AppFonts.x14Regular),
              onTap: widget.menuItems[index].onTap,
            ),
          ),
        ),
      ),
    );
  }
}
