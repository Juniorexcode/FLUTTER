import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onirisoft - Videojuegos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dreamyTheme,
      home: const LandingPage(),

    );
  }
}
