import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/send_order/send_order_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../utils/show_dialog.dart';

class SelectMitraPage extends StatelessWidget {
  final int? orderId;

  const SelectMitraPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              height: screenHeight / 5,
              child: Container(
                color: Colors.black,
                child: _detailHeadline(textTheme),
              ),
            ),
            Positioned(
              bottom: 100,
              width: screenWidth,
              height: screenHeight - (screenHeight / 2.45),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Placeholder(),
              ),
            ),
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight / 8,
              child: Container(
                color: AppColors.surface,
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _stateError(BuildContext context, OrderError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error fetching problems',
        state.errorMessage,
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.refresh_outlined),
        ),
      );
    });
  }

  Padding _detailHeadline(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berikut solusi dari\nHelpMe!',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.darkTextColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // TODO: Change later for mitra later REMEMBER
          LimitedBox(
            maxHeight: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return const CircleAvatar(
                  radius: 39,
                  backgroundColor: AppColors.backgroundColor,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      '',
                      maxWidth: 36,
                      maxHeight: 36,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'Help Me!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
