import 'package:help_me_mitra_alpha_ver/models/order_model.dart';

abstract class FetchOrderState {}

class FetchOrderInitialState extends FetchOrderState {}

class FetchOrderLoadingState extends FetchOrderState {}

// State untuk menyimpan daftar order
class FetchOrderLoadedState extends FetchOrderState {
  final List<OrderModel> orders;

  FetchOrderLoadedState(this.orders);
}

// State untuk menyimpan detail order saat diklik
class FetchOrderDetailLoadedState extends FetchOrderState {
  final OrderModel orderDetail;

  FetchOrderDetailLoadedState(this.orderDetail);
}

class FetchOrderErrorState extends FetchOrderState {
  final String error;

  FetchOrderErrorState(this.error);
}

// part of 'fetch_order_bloc.dart'; // Update to fetch_order_bloc.dart

// sealed class FetchOrderState extends Equatable { // Update to FetchOrderState
//   const FetchOrderState();

//   @override
//   List<Object> get props => [];
// }

// final class FetchOrderInitial extends FetchOrderState {} // Update to FetchOrderState

// final class FetchOrderLoading extends FetchOrderState {} // Update to FetchOrderLoading

// final class FetchOrderLoaded extends FetchOrderState { // Update to FetchOrderLoaded
//   final OrderResponseModel data; // Update to OrderResponseModel

//   const FetchOrderLoaded({required this.data});

//   @override
//   List<Object> get props => [data];
// }

// final class FetchOrderError extends FetchOrderState { // Update to FetchOrderError
//   final String message;

//   const FetchOrderError({required this.message});

//   @override
//   List<Object> get props => [message];
// }
