import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:url_launcher/url_launcher.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/chat/chat_response_model.dart';
import '../../models/order/detail_order_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/api/api_helper.dart';
import '../../utils/image_picker_util.dart';

part 'detail_order_state.dart';

class DetailOrderCubit extends Cubit<DetailOrderState> {
  final ImagePickerUtil imagePickerUtil;

  DetailOrderCubit({required this.imagePickerUtil})
      : super(DetailOrderInitial());

  int? chatId;
  DetailOrderModel? order;
  io.Socket? socket;
  XFile? selectedImg;

  List<ChatResponseModel> chats = [];

  void isIdle() => emit(DetailOrderIdle());

  // TODO: Untuk sekarang ini hanya support nomor region indonesia
  void openWhatsApp(String phoneNumber) async {
    final indonesiaFormatNumber = '+62${phoneNumber.substring(1)}';
    final Uri whatsAppUrl = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: indonesiaFormatNumber,
    );
    if (await canLaunchUrl(whatsAppUrl)) {
      emit(OpenWhatsApp());
      await launchUrl(whatsAppUrl);
    } else {
      emit(const OpenWhatsAppError(
        message:
            'Gagal membuka WhatsApp, pastikan aplikasi terinstall dan nomer valid',
      ));
    }
  }

  void fetchDetailOrder({required int orderId}) async {
    emit(DetailOrderLoading());
    final response = await ApiHelper.getDetailOrder(orderId);
    if (response is ApiErrorResponseModel) {
      var message = response.error?.error ?? response.error?.message;
      emit(DetailOrderError(message: message.toString()));
    } else {
      order = response;
      emit(DetailOrderLoaded(data: response));
    }
  }

  void createChatRoom({required int orderId}) async {
    emit(DetailOrderLoading());
    final response = await ApiHelper.createChatRoom(orderId);
    if (response is ApiErrorResponseModel) {
      var message = response.error?.error ?? response.error?.message;
      emit(DetailOrderError(message: message.toString()));
    } else {
      chatId = response;
      emit(CreateChatRoomSuccess(roomId: chatId!));
    }
  }

  void disconnectChat() {
    if (socket != null && socket!.active) {
      socket!.dispose();
      socket = null;
    }
  }

  void listenToChat() async {
    socket = io.io(
      ApiController.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .build(),
    );
    if (socket != null && chatId != null && chatId != 0) {
      socket!
        ..onConnect((response) {
          log('Connected: ${response.toString()}', name: 'Connected to chat');
          socket!.emit('join_chat', chatId);
          emit(ConnectedToChat());
        })
        ..onConnectError((response) {
          log('Error connect: ${response.toString()}',
              name: 'Error connecting chat');
          emit(ErrorChat(message: response.toString()));
        })
        ..onDisconnect((response) {
          log('Disconnect: ${response.toString()}',
              name: 'Disconnected from chat');
          emit(DisconnectedFromChat());
        })
        ..onReconnectAttempt((response) {
          log('Attempting reconnect: ${response.toString()}',
              name: 'Reconnected to chat');
          emit(ReconnectingToChat());
        })
        ..onReconnectError((response) {
          log('Error reconnect: ${response.toString()}',
              name: 'Error reconnecting to chat');
          emit(ErrorChat(message: response.toString()));
        })
        ..onReconnectFailed((response) {
          log('Failed to reconnect: ${response.toString()}',
              name: 'Failed reconnect to chat');
          emit(FailedReconnectToChat());
        })
        ..on('message', (response) {
          log(response.toString(), name: 'Receiving message');
          final message = ChatResponseModel.fromJson(response);
          emit(ReceiveChat(response: message));
        });
    } else {
      emit(const ErrorChat(message: 'Chat id is null'));
    }
  }

  void cameraCapture() async {
    XFile? imagePicked = await imagePickerUtil.cameraCapture();
    if (imagePicked != null) {
      selectedImg = imagePicked;
      emit(ImageSelected(image: imagePicked));
    } else {
      emit(DetailOrderIdle());
    }
  }

  void galleryImagePicker() async {
    XFile? imagePicked = await imagePickerUtil.imageFromGallery();
    if (imagePicked != null) {
      selectedImg = imagePicked;
      emit(ImageSelected(image: imagePicked));
    } else {
      emit(DetailOrderIdle());
    }
  }
}
