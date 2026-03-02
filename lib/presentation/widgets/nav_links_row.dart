import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import 'nav_bar_item.dart';
import '../../domain/models/nav_item.dart';

/// A horizontal row of navigation links for the nav bar.
///
/// Receives a list of [NavItem] definitions instead of hardcoding destinations.
class NavLinksRow extends StatelessWidget {
  final List<NavItem> items;
  final void Function(double offset) onNavigate;

  const NavLinksRow({
    super.key,
    required this.items,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildItems(),
    );
  }

  List<Widget> _buildItems() {
    final widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) {
        widgets.add(SizedBox(width: AppDimensions.navLinkSpacing));
      }
      final item = items[i];
      widgets.add(
        NavBarItem(
          title: item.title,
          onTap: () => onNavigate(item.scrollOffset),
        ),
      );
    }
    return widgets;
  }
}
