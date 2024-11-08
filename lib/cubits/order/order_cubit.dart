import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/order/order_recieved.dart';

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
}
