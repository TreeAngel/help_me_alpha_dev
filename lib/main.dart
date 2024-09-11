import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_theme.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/home_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/register_page.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: AppTheme.appTheme,
      home: const LoginPageView(),
    );
  }
}
