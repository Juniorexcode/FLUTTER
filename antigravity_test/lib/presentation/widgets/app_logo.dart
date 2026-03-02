import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Logo reutilizable de la marca Onirisoft.
///
/// Muestra el icono gamepad + el nombre "Onirisoft".
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.gamepad, color: AppTheme.primary, size: 32),
        const SizedBox(width: 12),
        Text(
          'Onirisoft',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                letterSpacing: 1.2,
              ),
        ),
      ],
    );
  }
}
