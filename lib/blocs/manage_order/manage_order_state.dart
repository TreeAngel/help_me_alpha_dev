part of 'manage_order_bloc.dart';

sealed class ManageOrderState extends Equatable {
  const ManageOrderState();

  @override
  List<Object> get props => [];
}

final class ManageOrderInitial extends ManageOrderState {}

final class ManageOrderIdle extends ManageOrderState {}

final class ManageOrderLoading extends ManageOrderState {}

final class OfferFromMitraLoaded extends ManageOrderState {
  final OfferResponseModel data;

  const OfferFromMitraLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class OfferFromMitraError extends ManageOrderState {
  final String message;

  const OfferFromMitraError({required this.message});

  @override
  List<Object> get props => [message];
}

final class PaymentCodeRequested extends ManageOrderState {
  final String code;

  const PaymentCodeRequested({required this.code});

  @override
  List<Object> get props => [code];
}

final class PaymentCodeError extends ManageOrderState {
  final String message;

  const PaymentCodeError({required this.message});

  @override
  List<Object> get props => [message];
}
