import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';

class ImageZoomPage extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> imageNames;

  const ImageZoomPage({
    super.key,
    required this.imagePaths,
    required this.imageNames,
  });

  @override
  State<ImageZoomPage> createState() => _ImageZoomPageState();
}

class _ImageZoomPageState extends State<ImageZoomPage> {
  late List<String> imagePaths;
  late List<String> imageNames;
  late String selectedImage;
  late String selectedName;

  @override
  void initState() {
    super.initState();
    imagePaths = widget.imagePaths;
    imageNames = widget.imageNames;
    selectedImage = imagePaths.first;
    selectedName = imageNames.first;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      child: Scaffold(
        appBar: _appBar(context, textTheme, selectedName),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Hero(
                tag: widget.imageNames,
                child: Image.file(File(selectedImage)),
              ),
              Positioned(
                bottom: 20,
                child: ListView.builder(
                  itemCount: imagePaths.length,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selectedImage != imagePaths[index] &&
                            selectedName != imageNames[index]) {
                          selectedImage = selectedImage[index];
                          selectedName = imageNames[index];
                        }
                      }),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.lightTextColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
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
