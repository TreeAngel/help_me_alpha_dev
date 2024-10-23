import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';
import '../../../cubits/detail_order/detail_order_cubit.dart';
import '../../../data/menu_items_data.dart';
import '../../../models/misc/menu_item_model.dart';
import '../../../models/order/chat/chat_response_model.dart';
import '../../../utils/logging.dart';
import '../../../utils/show_dialog.dart';
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
  List<ChatResponseModel> chats = [];
  final TextEditingController _chatInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    // final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    chats = context.watch<DetailOrderCubit>().chats;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(textTheme),
        body: BlocConsumer<DetailOrderCubit, DetailOrderState>(
          listener: (context, state) {
            if (state is ErrorChat) {
              ShowDialog.showAlertDialog(
                context,
                'Peringatan!',
                state.message,
                null,
              );
            }
            if (state is ReceiveChat) {
              context.read<DetailOrderCubit>().isIdle();
            }
            if (state is ImageSelected) {
              showDialog(
                useSafeArea: true,
                barrierDismissible: false,
                context: context,
                builder: (context) => Dialog.fullscreen(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackButton(
                        onPressed: () => context.pop(),
                      ),
                      Image.file(
                        File(state.image.path),
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          // TODO: Implement send chat message
                          onPressed: () {},
                          icon: const Icon(Icons.send_rounded),
                          style: const ButtonStyle(
                            iconColor: WidgetStatePropertyAll(
                              AppColors.lightTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            context.read<DetailOrderCubit>().isIdle();
            if (context.read<DetailOrderCubit>().socket == null) {
              context.read<DetailOrderCubit>().listenToChat();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView.builder(
                  itemCount: chats.length,
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 10,
                  ),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return _bubbleChat(
                      chat.message,
                      sendTime: chat.createdAt!,
                      senderId: chat.senderId!,
                      userId: widget.userId,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: _chatInputContainer(screenHeight, textTheme),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _chatInputContainer(double screenHeight, TextTheme textTheme) {
    return Container(
      // height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightTextColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 2.5),
            spreadRadius: 1,
            color: AppColors.lightTextColor,
            blurRadius: 1,
            blurStyle: BlurStyle.inner,
          ),
          BoxShadow(
            offset: Offset(1, 0),
            spreadRadius: 1,
            color: AppColors.lightTextColor,
            blurRadius: 1,
            blurStyle: BlurStyle.inner,
          ),
          BoxShadow(
            offset: Offset(-1, 0),
            spreadRadius: 1,
            color: AppColors.lightTextColor,
            blurRadius: 1,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _pickImageBtn(context)),
          Expanded(
            flex: 10,
            child: TextFormField(
              controller: _chatInputController,
              keyboardType: TextInputType.text,
              scrollPhysics: const ClampingScrollPhysics(),
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                suffixIconColor: Colors.black,
                border: InputBorder.none,
                hintText: 'Ketik pesan',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: AppColors.hintTextColor,
                  decoration: TextDecoration.none,
                ),
              ),
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              // TODO: Implement send chat message
              onPressed: () {},
              icon: const Icon(Icons.send_rounded),
              style: const ButtonStyle(
                iconColor: WidgetStatePropertyAll(
                  AppColors.lightTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<MenuItemModel> _pickImageBtn(
    BuildContext context,
  ) {
    return PopupMenuButton<MenuItemModel>(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.lightTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.transparent,
      tooltip: 'Ambil gambar',
      position: PopupMenuPosition.under,
      icon: const Icon(
        Icons.image_outlined,
        color: AppColors.lightTextColor,
      ),
      onSelected: (value) => _pickImageMenuFunction(context, value),
      itemBuilder: (context) => [...MenuItems.pickImageItems.map(_buildItem)],
    );
  }

  PopupMenuItem<MenuItemModel> _buildItem(MenuItemModel item) =>
      PopupMenuItem<MenuItemModel>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon),
            const SizedBox(width: 10),
            Text(item.title),
          ],
        ),
      );

  void _pickImageMenuFunction(
    BuildContext context,
    MenuItemModel item,
  ) {
    switch (item) {
      case MenuItems.itemFromCamera:
        context.read<DetailOrderCubit>().cameraCapture();
        break;
      case MenuItems.itemFromGallery:
        context.read<DetailOrderCubit>().galleryImagePicker();
        break;
      default:
        printError('What are you tapping? $item');
        break;
    }
  }

  Row _bubbleChat(
    String? message, {
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _mitraProfile(),
        )
      ],
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
