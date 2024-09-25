import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return GestureDetector(
      child: Scaffold(
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
}
