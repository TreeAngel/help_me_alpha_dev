import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key, required this.problemId, required this.problem});

  final int? problemId;
  final String? problem;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              child: Container(
                height: screenHeight / 1 - (screenHeight / 2.8),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('') // TODO: Integrate with string 'builder' function
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.lightTextColor,
      title: Text(
        'Form Bantuan',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
