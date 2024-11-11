import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/order_recieved.dart';
import '../../services/api/api_helper.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  List<OrderReceived> incomingOrder = [];

  void orderInit() => emit(OrderInitial());

  void orderIsIdle() => emit(OrderIdle());

  void orderDisposed() {
    if (incomingOrder.isNotEmpty) incomingOrder.clear();
    emit(OrderDispose());
  }

  void receivingOrder(OrderReceived order) {
    if (!incomingOrder.contains(order)) {
      incomingOrder.add(order);
      emit(ReceivingOrder());
    }
  }

  void getAvailableOrder() async {
    final response = await ApiHelper.getAvailableOrder();
    if (response is ApiErrorResponseModel) {
      String? message = response.error?.error ?? response.error?.message;
      if (message == null || message.isEmpty) {
        message = response.toString();
      }
      if (message.toString().toLowerCase().trim().contains('no order found')) {
        emit(NoAvailableOrder(message: message.toString()));
      } else {
        emit(AvailableOrderError(message: message.toString()));
      }
    } else {
      emit(AvailableOrderLoaded(orders: response));
    }
  }
}
