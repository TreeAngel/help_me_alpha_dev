import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_me_client_alpha_ver/configs/app_colors.dart';

class AppTheme {
  static ThemeData get appTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.surface,
        // brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
    );
  }
}
