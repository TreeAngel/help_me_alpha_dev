import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/detail_order_model.dart';
import '../../services/api/api_helper.dart';

part 'detail_order_state.dart';

class DetailOrderCubit extends Cubit<DetailOrderState> {
  DetailOrderCubit() : super(DetailOrderInitial());

  int? chatId;
  DetailOrderModel? order;

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
}
