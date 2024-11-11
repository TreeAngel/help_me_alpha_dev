part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderIdle extends OrderState {}

final class OrderDispose extends OrderState {}

final class ReceivingOrder extends OrderState {}

final class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}

final class AvailableOrderLoaded extends OrderState {
  final List<OrderReceived> orders;

  const AvailableOrderLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class NoAvailableOrder extends OrderState {
  final String message;

  const NoAvailableOrder({required this.message});

  @override
  List<Object> get props => [message];
}

final class AvailableOrderError extends OrderState {
  final String message;

  const AvailableOrderError({required this.message});

  @override
  List<Object> get props => [message];
}
