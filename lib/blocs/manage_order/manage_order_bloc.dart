import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/offer/select_mitra_response_model/select_mitra_response_model.dart';
import '../../services/api/api_helper.dart';

part 'manage_order_event.dart';
part 'manage_order_state.dart';

class ManageOrderBloc extends Bloc<ManageOrderEvent, ManageOrderState> {
  bool haveActiveOrder = false;
  String? snapToken;

  ManageOrderBloc() : super(ManageOrderInitial()) {
    on<SelectMitraSubmitted>(_onSelectMitraSubmitted);

    on<RequestSnapToken>(_onRequestSnapToken);
  }

  Future<void> _onRequestSnapToken(event, emit) async {
    emit(ManageOrderLoading());
    final response = await ApiHelper.orderPayment(event.orderId);
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      emit(SnapTokenError(message: message.toString()));
    } else {
      emit(SnapTokenRequested(code: response['snap_token']));
      snapToken = response['snap_token'];
    }
  }

  Future<void> _onSelectMitraSubmitted(event, emit) async {
    emit(ManageOrderLoading());
    final response = await ApiHelper.selectMitra(event.offerId);
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      emit(SelectMitraError(message: message.toString()));
    } else {
      emit(SelectMitraSuccess(data: response));
    }
  }
}
