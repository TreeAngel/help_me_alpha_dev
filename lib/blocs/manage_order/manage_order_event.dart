part of 'manage_order_bloc.dart';

sealed class ManageOrderEvent extends Equatable {
  const ManageOrderEvent();

  @override
  List<Object> get props => [];
}

final class FetchOffer extends ManageOrderEvent {
  final int orderId;

  const FetchOffer({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

final class SelectMitraSubmitted extends ManageOrderEvent {
  final int offerId;

  const SelectMitraSubmitted({required this.offerId});

  @override
  List<Object> get props => [offerId];
}

final class RequestPaymentCode extends ManageOrderEvent {
  final int orderId;

  const RequestPaymentCode({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
