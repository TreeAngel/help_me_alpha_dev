import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';
import '../../../cubits/profile/profile_cubit.dart';

class SendOfferPage extends StatefulWidget {
  final int orderId;
  final double distance;
  final String problem;
  final String category;
  final List<String> attachments;

  const SendOfferPage({
    super.key,
    required this.orderId,
    required this.distance,
    required this.problem,
    required this.category,
    required this.attachments,
  });

  @override
  State<SendOfferPage> createState() => _SendOfferPageState();
}

// TODO: page send order
class _SendOfferPageState extends State<SendOfferPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: _appBar(textTheme),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight / 2.1,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(TextTheme textTheme) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.lightTextColor,
      leading: IconButton.filled(
        onPressed: () => context.pop(),
        style: const ButtonStyle(
          maximumSize: WidgetStatePropertyAll(
            Size(40, 40),
          ),
          backgroundColor: WidgetStatePropertyAll(
            AppColors.surface,
          ),
        ),
        icon: const Icon(
          Icons.close,
          color: AppColors.lightTextColor,
        ),
      ),
      title: Text(
        'Orderan',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _mitraProfile(),
      ],
    );
  }

  Padding _mitraProfile() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 18,
          backgroundImage:
              context.read<ProfileCubit>().userProfile?.imageProfile != null
                  ? CachedNetworkImageProvider(
                      context.read<ProfileCubit>().userProfile!.imageProfile!,
                    )
                  : const AssetImage(
                      'assets/images/man1.png',
                    ),
        ),
      ),
    );
  }
}
