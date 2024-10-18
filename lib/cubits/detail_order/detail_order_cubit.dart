import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/detail_order_model.dart';
import '../../services/api/api_helper.dart';

part 'detail_order_state.dart';

class DetailOrderCubit extends Cubit<DetailOrderState> {
  DetailOrderCubit() : super(DetailOrderInitial());

  void isIdle() {
    emit(DetailOrderIdle());
  }

  void openWhatsApp(String phoneNumber) async {
    final Uri whatsAppUrl = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
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
      emit(DetailOrderLoaded(data: response));
    }
  }
}
