import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_mitra_alpha_ver/services/api/api_helper.dart';
import 'package:help_me_mitra_alpha_ver/models/order_model.dart';
import 'package:help_me_mitra_alpha_ver/models/order_response_model.dart';
import 'fetch_order_event.dart';
import 'fetch_order_state.dart';

// untuk menangani notifikasi
class FetchOrderNotificationEvent extends FetchOrderEvent {
  final String title;
  final String body;

  FetchOrderNotificationEvent(this.title, this.body);
}

class FetchOrderBloc extends Bloc<FetchOrderEvent, FetchOrderState> {
  FetchOrderBloc() : super(FetchOrderInitialState());

  @override
  Stream<FetchOrderState> mapEventToState(FetchOrderEvent event) async* {
    if (event is FetchOrdersEvent) {
      yield FetchOrderLoadingState();
      try {
        // Panggil API untuk mendapatkan daftar order
        final orders = await ApiHelper.getOrders();
        yield FetchOrderLoadedState(orders);
      } catch (e) {
        yield FetchOrderErrorState(e.toString());
      }
    }

    // Handle klik order untuk mengambil detail dari users/orders/$orderId
    else if (event is FetchOrderDetailEvent) {
      yield FetchOrderLoadingState();
      try {
        // Panggil API untuk mendapatkan detail order dengan orderId
        final orderDetail = await ApiHelper.getOrderDetail(event.orderId);
        yield FetchOrderDetailLoadedState(orderDetail);
      } catch (e) {
        yield FetchOrderErrorState(e.toString());
      }
    }

    // Handle notifikasi order
    else if (event is FetchOrderFromNotificationEvent) {
      yield FetchOrderLoadingState();
      try {
        // Panggil API untuk mendapatkan detail order berdasarkan order_id dari notifikasi
        final orderDetail = await ApiHelper.getOrderDetail(event.orderId);
        yield FetchOrderDetailLoadedState(orderDetail);
      } catch (e) {
        yield FetchOrderErrorState(e.toString());
      }
    }
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

// import '../../models/api_error_response/api_error_response_model.dart';
// import '../../models/order_model.dart';
// import '../../models/order_response_model.dart';
// import '../../services/api/api_helper.dart';

// part 'fetch_order_event.dart';
// part 'fetch_order_state.dart';


// class FetchOrderBloc extends Bloc<FetchOrderEvent, FetchOrderState> {
//   List<OrderModel> orderList = [];

//   FetchOrderBloc() : super(FetchOrderInitial()) {
//     on<FetchOrder>(_onFetchOrder);
//   }

//   Future<void> _onFetchOrder(event, emit) async {
//     emit(FetchOrderLoading());
//     await emit.forEach(
//       ApiHelper.getOrderFromClient(event.orderId), // Pastikan API ini mengembalikan stream
//       onData: (response) {
//         if (response is ApiErrorResponseModel) {
//           final message = response.error?.error ?? response.error?.message;
//           return FetchOrderError(message: message.toString());
//         } else {
//           return FetchOrderLoaded(data: response); // Emit loaded state dengan data
//         }
//       },
//       onError: (error, stackTrace) {
//         return FetchOrderError(message: error.toString()); // Emit error state
//       },
//     );
//   }
// }


// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

// import '../../models/api_error_response/api_error_response_model.dart';
// import '../../models/order/order_model.dart';  // Update model to OrderModel
// import '../../models/order/order_response_model.dart'; // Update model to OrderResponseModel
// import '../../services/api/api_helper.dart';

// part 'fetch_order_event.dart'; // Change to fetch_order_event.dart
// part 'fetch_order_state.dart'; // Change to fetch_order_state.dart

// class FetchOrderBloc extends Bloc<FetchOrderEvent, FetchOrderState> {
//   List<OrderModel> orderList = []; // Update to orderList

//   FetchOrderBloc() : super(FetchOrderInitial()) {
//     on<FetchOrder>(_onFetchOrder); // Update function call
//   }

//   Future<void> _onFetchOrder(event, emit) async {
//     emit(FetchOrderLoading()); // Update to FetchOrderLoading
//     await emit.forEach(
//       ApiHelper.getOrderFromClient(event.orderId), // Update API call
//       onData: (response) {
//         if (response is ApiErrorResponseModel) {
//           final message = response.error?.error ?? response.error?.message;
//           return FetchOrderError(message: message.toString()); // Update to FetchOrderError
//         } else {
//           return FetchOrderLoaded(data: response); // Update to FetchOrderLoaded
//         }
//       },
//       onError: (error, stackTrace) {
//         return FetchOrderError(message: error.toString()); // Update to FetchOrderError
//       },
//     );
//   }
// }
