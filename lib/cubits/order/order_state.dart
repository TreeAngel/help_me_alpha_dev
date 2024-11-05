part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderIdle extends OrderState {}

final class OrderDispose extends OrderState {}

final class OrderRecieve extends OrderState {
  final OrderRecieved order;

  const OrderRecieve({required this.order});

  @override
  List<Object> get props => [order];
}

final class OrderRecieveError extends OrderState {
  final String message;

  const OrderRecieveError({required this.message});

  @override
  List<Object> get props => [message];
}
