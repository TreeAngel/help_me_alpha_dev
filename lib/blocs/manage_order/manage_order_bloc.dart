import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/offer/offer_model.dart';
import '../../models/offer/offer_response_model.dart';
import '../../services/api/api_helper.dart';

part 'manage_order_event.dart';
part 'manage_order_state.dart';

class ManageOrderBloc extends Bloc<ManageOrderEvent, ManageOrderState> {
  bool haveActiveOrder = false;
  String? paymentCode;
  List<OfferModel> offerList = [];
  StreamSubscription? _offerSubscription;

  ManageOrderBloc() : super(ManageOrderInitial()) {
    on<FetchOffer>(_onFetchOffer);

    on<PauseFetching>((event, emit) {
      _offerSubscription?.pause();
      emit(ManageOrderIdle());
    });

    on<StopFetching>((event, emit) {
      _offerSubscription?.cancel();
      emit(ManageOrderInitial());
    });
  }

  @override
  Future<void> close() {
    _offerSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetchOffers(event, emit) async {
    emit(ManageOrderLoading());
    await emit.forEach(
      ApiHelper.getOfferFromMitra(event.orderId),
      onData: (response) {
        if (response is ApiErrorResponseModel) {
          final message = response.error?.error ?? response.error?.message;
          return OfferFromMitraError(message: message.toString());
        } else {
          return OfferFromMitraLoaded(data: response);
        }
      },
      onError: (error, stackTrace) {
        return OfferFromMitraError(message: error.toString());
      },
    );
  }

  // Future untuk meng-handle event FetchOffer
  Future<void> _onFetchOffer(
      FetchOffer event, Emitter<ManageOrderState> emit) async {
    emit(ManageOrderLoading());

    // Emit Stream menggunakan emit.forEach()
    await emit.forEach(
      ApiHelper.getOfferFromMitra(
          event.orderId), // Ambil stream dari API helper
      onData: (response) {
        if (response is ApiErrorResponseModel) {
          final message = response.error?.error ?? response.error?.message;
          return OfferFromMitraError(message: message.toString());
        } else {
          return OfferFromMitraLoaded(data: response);
        }
      },
      onError: (error, stackTrace) {
        return OfferFromMitraError(message: error.toString());
      },
    );

    // Subscribe ke stream dan simpan subscription-nya
    _offerSubscription = ApiHelper.getOfferFromMitra(event.orderId).listen(
      (response) {
        if (response is OfferResponseModel) {
          emit(OfferFromMitraLoaded(data: response));
        } else {
          emit(OfferFromMitraError(message: 'Error loading offer'));
        }
      },
      onError: (error) {
        emit(OfferFromMitraError(message: error.toString()));
      },
    );
  }
}
