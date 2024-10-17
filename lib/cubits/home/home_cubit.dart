import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_problem/category_model.dart';
import '../../models/order/history/order_history_model.dart';
import '../../models/auth/user_model.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  String username = 'Kamu!';
  List<CategoryModel> allCategories = [];
  List<CategoryModel> fourCategories = [];
  List<OrderHistoryModel> orderHistory = [];
  OrderHistoryModel? lastHistory;

  HomeCubit() : super(HomeInitial());

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    final response = await ApiHelper.getCategories();
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      emit(CategoryError(errorMessage: message.toString()));
    } else {
      emit(CategoryLoaded(categories: response.data));
    }
  }

  Future<void> fetchProfile() async {
    emit(HomeLoading());
    final response = await ApiHelper.getUseProfile();
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      emit(ProfileError(errorMessage: message.toString()));
    } else {
      emit(ProfileLoaded(data: response));
    }
  }

  Future<void> fetchHistory({String? status}) async {
    emit(HomeLoading());
    final response = await ApiHelper.getOrderHistory(status ?? '');
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      if (message.toString().toLowerCase().trim().contains('no order found')) {
        emit(const OrderHistoryLoaded(history: <OrderHistoryModel>[]));
      } else {
        emit(OrderHistoryError(errorMessage: message.toString()));
      }
    } else {
      emit(OrderHistoryLoaded(history: response));
    }
  }

  void homeIdle() {
    emit(HomeIdle());
  }

  void disposeHome() {
    username = 'Kamu!';
    allCategories = [];
    fourCategories = [];
    orderHistory = [];
    lastHistory = null;
    emit(HomeInitial());
  }
}
