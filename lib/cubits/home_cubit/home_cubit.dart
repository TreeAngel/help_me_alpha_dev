import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_problem/category_model.dart';
import '../../models/order/history/order_history_model.dart';
import '../../models/auth/user_model.dart';
import '../../services/api/api_controller.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiController apiController;

  String username = 'Kamu!';
  List<CategoryModel> allCategories = [];
  List<CategoryModel> fourCategories = [];
  List<OrderHistoryModel> orderHistory = [];
  OrderHistoryModel? lastHistory;

  HomeCubit({required this.apiController}) : super(HomeInitial());

  Future<void> fetchHome({String? historyStatus}) async {
    emit(HomeLoading());
    final profile = await ApiHelper.getUseProfile();
    final categories = await ApiHelper.getCategories();
    final histories = await ApiHelper.getOrderHistory(historyStatus ?? '');
    if (profile is ApiErrorResponseModel) {
      final message = profile.error?.error ?? profile.error?.message;
      emit(ProfileError(errorMessage: message.toString()));
    } else if (categories is ApiErrorResponseModel) {
      final message = categories.error?.error ?? categories.error?.message;
      emit(CategoryError(errorMessage: message.toString()));
    } else if (histories is ApiErrorResponseModel) {
      final message = histories.error?.error ?? histories.error?.message;
      emit(OrderHistoryError(errorMessage: message.toString()));
    } else {
      emit(HomeLoaded(
        profile: profile,
        categories: categories.data,
        histories: histories,
      ));
    }
  }

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    final response = await ApiHelper.getCategories();
    if (response is ApiErrorResponseModel) {
      emit(CategoryError(errorMessage: response.error!.error.toString()));
    } else {
      emit(CategoryLoaded(categories: response.data));
    }
  }

  Future<void> fetchProfile() async {
    emit(HomeLoading());
    final response = await ApiHelper.getUseProfile();
    if (response is ApiErrorResponseModel) {
      emit(ProfileError(errorMessage: response.error!.error.toString()));
    } else {
      emit(ProfileLoaded(data: response));
    }
  }

  Future<void> fetchHistory({String? status}) async {
    emit(HomeLoading());
    final response = await ApiHelper.getOrderHistory(status ?? '');
    if (response is ApiErrorResponseModel) {
      final message = response.error?.error ?? response.error?.message;
      if (message.toString().toLowerCase().trim().contains('order not found')) {
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
}
