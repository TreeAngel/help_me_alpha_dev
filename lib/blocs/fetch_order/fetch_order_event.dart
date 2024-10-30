import 'package:equatable/equatable.dart';

abstract class FetchOrderEvent {}

// Event untuk mendapatkan daftar order
class FetchOrdersEvent extends FetchOrderEvent {}

// Event untuk mendapatkan detail order dengan orderId
class FetchOrderDetailEvent extends FetchOrderEvent {
  final int orderId;

  FetchOrderDetailEvent(this.orderId);
}

class FetchOrderFromNotificationEvent extends FetchOrderEvent {
  final int orderId;

  FetchOrderFromNotificationEvent(this.orderId);
}

// part of 'fetch_order_bloc.dart';

// sealed class FetchOrderEvent extends Equatable {
//   const FetchOrderEvent();

//   @override
//   List<Object> get props => [];
// }

// final class FetchOrder extends FetchOrderEvent {
//   final int orderId;

//   const FetchOrder({required this.orderId});

//   @override
//   List<Object> get props => [orderId];
// }


// part of 'fetch_order_bloc.dart'; // Update to fetch_order_bloc.dart

// sealed class FetchOrderEvent extends Equatable { // Update to FetchOrderEvent
//   const FetchOrderEvent();

//   @override
//   List<Object> get props => [];
// }

// final class FetchOrder extends FetchOrderEvent { // Update to FetchOrder
//   final int orderId;

//   const FetchOrder({required this.orderId});

//   @override
//   List<Object> get props => [orderId];
// }
