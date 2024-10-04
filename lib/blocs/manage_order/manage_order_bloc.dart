import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/offer/offer_response_model.dart';
import '../../models/offer/select_mitra_response_model/select_mitra_response_model.dart';
import '../../services/api/api_controller.dart';

part 'manage_order_event.dart';
part 'manage_order_state.dart';

class ManageOrderBloc extends Bloc<ManageOrderEvent, ManageOrderState> {
  final ApiController apiController;

  bool haveActiveOrder = false;

  ManageOrderBloc({required this.apiController}) : super(ManageOrderInitial()) {
    on<ManageOrderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
