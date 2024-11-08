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
