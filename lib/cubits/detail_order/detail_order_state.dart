part of 'detail_order_cubit.dart';

sealed class DetailOrderState extends Equatable {
  const DetailOrderState();

  @override
  List<Object> get props => [];
}

final class DetailOrderInitial extends DetailOrderState {}

final class DetailOrderIdle extends DetailOrderState {}

final class DetailOrderLoading extends DetailOrderState {}

final class DetailOrderLoaded extends DetailOrderState {
  final DetailOrderModel data;

  const DetailOrderLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class DetailOrderError extends DetailOrderState {
  final String message;

  const DetailOrderError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ListeningOrderStatus extends DetailOrderState {}

final class ListeningOrderStatusError extends DetailOrderState {
  final String message;

  const ListeningOrderStatusError({required this.message});

  @override
  List<Object> get props => [message];
}

final class OpenWhatsApp extends DetailOrderState {}

final class OpenWhatsAppError extends DetailOrderState {
  final String message;

  const OpenWhatsAppError({required this.message});

  @override
  List<Object> get props => [message];
}

final class CreateChatRoomSuccess extends DetailOrderState {
  final int roomId;

  const CreateChatRoomSuccess({required this.roomId});

  @override
  List<Object> get props => [roomId];
}
