part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchProblems extends OrderEvent {
  final int id;

  const FetchProblems({required this.id});

  @override
  List<Object> get props => [id];
}