import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Individual navigation item with hover glow effect.
class NavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const NavBarItem({super.key, required this.title, required this.onTap});

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: isHovered ? AppTheme.secondary : Colors.white70,
            fontSize: 16,
            fontWeight: isHovered ? FontWeight.bold : FontWeight.w500,
            shadows: isHovered
                ? [
                    const BoxShadow(
                      color: AppTheme.secondary,
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Text(widget.title),
        ),
      ),
    );
  }
}
