import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';

class ImageZoomPage extends StatelessWidget {
  const ImageZoomPage({
    super.key,
    required this.imagePath,
    required this.imageName,
  });

  final String imagePath;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      child: Scaffold(
        appBar: _appBar(context, textTheme, imageName),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Hero(
            tag: imageName,
            child: Image.file(File(imagePath)),
          ),
        ),
      ),
      onTap: () => context.pop(),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme, String title) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
