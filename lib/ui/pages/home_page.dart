import 'package:flutter/material.dart';
import 'package:help_me_alpha_dev/configs/app_colors.dart';
import 'package:help_me_alpha_dev/ui/widgets/gradient_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final colorScheme = appTheme.colorScheme;

    return const Scaffold(

      body: Placeholder(),
    );
  }
}
