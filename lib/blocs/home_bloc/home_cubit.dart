import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_model.dart';
import '../../models/order_history_model.dart';
import '../../models/user_model.dart';
import '../../services/api/api_controller.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiController apiController;

  HomeCubit({required this.apiController}) : super(HomeInitial());

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    try {
      final response = await ApiHelper.getCategories();
      if (response is ApiErrorResponseModel) {
        emit(CategoryError(errorMessage: response.error!.error.toString()));
      } else {
        emit(CategoryLoaded(categories: response.data));
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchProfile() async {
    emit(HomeLoading());
    try {
      final response = await ApiHelper.getUseProfile();
      if (response is ApiErrorResponseModel) {
        emit(ProfileError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProfileLoaded(user: response));
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchHistory(String status) async {
    emit(HomeLoading());
    try {
      final response = await ApiHelper.getOrderHistory(status);
      if (response is ApiErrorResponseModel) {
        emit(OrderHistoryError(
            errorMessage: response.error?.error.toString() ??
                response.error!.message.toString()));
      } else {
        emit(OrderHistoryLoaded(history: response));
      }
    } catch (e) {
      emit(OrderHistoryError(errorMessage: e.toString()));
    }
  }
}
