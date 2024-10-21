import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/app_colors.dart';
import '../../../cubits/detail_order/detail_order_cubit.dart';
import '../../widgets/bubble_chat.dart';

class ChatPage extends StatefulWidget {
  final int userId;
  final int chatId;
  final String mitraName;
  final String imgPath;

  const ChatPage({
    super.key,
    required this.userId,
    required this.chatId,
    required this.mitraName,
    required this.imgPath,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(textTheme),
        body: BlocConsumer<DetailOrderCubit, DetailOrderState>(
          listener: (context, state) {},
          builder: (context, state) {
            return SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  _bubbleChat(
                    'P WOI BAYAR HUTANG',
                    null,
                    sendTime: DateTime(2024, 10, 21, 10, 24, 4),
                    senderId: 2,
                    userId: 1,
                  ),
                  const SizedBox(height: 10),
                  _bubbleChat(
                    null,
                    'https://e249e5482307a05ed073b16cfd9a3222.serveo.net/storage/chats/1/95f61c0d-b337-4eed-9c92-c9aec5b5151d.jpg',
                    sendTime: DateTime.now(),
                    senderId: 1,
                    userId: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Row _bubbleChat(
    String? message,
    String? attachment, {
    required DateTime sendTime,
    required int senderId,
    required int userId,
  }) {
    return Row(
      textDirection: senderId == userId ? TextDirection.rtl : TextDirection.ltr,
      children: [
        BubbleChat(
          sendTime: sendTime,
          senderId: senderId,
          userId: userId,
          message: message,
          attachment: attachment,
        ),
      ],
    );
  }

  AppBar _appBar(TextTheme textTheme) {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        widget.mitraName,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [_mitraProfile()],
    );
  }

  CircleAvatar _mitraProfile() {
    return CircleAvatar(
      maxRadius: 20,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        maxRadius: 16,
        backgroundImage: CachedNetworkImageProvider(widget.imgPath),
      ),
    );
  }
}
