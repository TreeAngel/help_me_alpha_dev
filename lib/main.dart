import 'package:flutter/material.dart';
import 'package:help_me_alpha_dev/configs/app_theme.dart';
import 'package:help_me_alpha_dev/ui/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.appTheme,
      home: const HomePage(),
    );
  }
}
