import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_problem/category_model.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order/history/order_history_model.dart';
import '../../services/api/api_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  List<CategoryModel> categories = [];
  List<CategoryModel> helpers = [];
  List<OrderHistoryModel> orderHistory = [];

  HomeCubit() : super(HomeInitial());

  void homeInit() => emit(HomeInitial());

  void homeIdle() => emit(HomeIdle());

  void disposeHome() {
    if (categories.isNotEmpty) categories.clear();
    if (orderHistory.isNotEmpty) orderHistory.clear();
    if (helpers.isNotEmpty) helpers.clear();
    emit(HomeDispose());
  }

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    try {
      final response = await ApiHelper.getCategories();
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.error ?? response.error?.message;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(CategoryError(errorMessage: message.toString()));
      } else {
        emit(CategoryLoaded(categories: response.data));
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchHelpers(String category) async {
    emit(HomeLoading());
    try {
      final response = await ApiHelper.getHelpers(category: category);
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.error ?? response.error?.message;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(HelperError(message: message.toString()));
      } else {
        emit(HelperLoaded(helpers: response.data));
      }
    } catch (e) {
      emit(HelperError(message: e.toString()));
    }
  }

  Future<void> fetchHistory({String? status}) async {
    emit(HomeLoading());
    final response = await ApiHelper.getMitraHistory();
    if (response is ApiErrorResponseModel) {
      String? message = response.error?.error ?? response.error?.message;
      if (message == null || message.isEmpty) {
        message = response.toString();
      }
      if (message.toString().toLowerCase().trim().contains('no order found')) {
        emit(const OrderHistoryLoaded(histories: <OrderHistoryModel>[]));
      } else {
        emit(OrderHistoryError(message: message.toString()));
      }
    } else {
      emit(OrderHistoryLoaded(histories: response));
    }
  }
}
