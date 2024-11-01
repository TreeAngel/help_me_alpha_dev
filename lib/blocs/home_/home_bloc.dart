import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_problem/category_model.dart';
import '../../models/auth/user_model.dart';
import '../../services/api/api_controller.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_helper.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiController apiController;

  HomeBloc({required this.apiController}) : super(HomeInitial()) {
    on<FetchCategories>(_onFetchCategories);

    on<FetchProfile>(_onFetchProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final response = await ApiHelper.getUserProfile();
      if (response is ApiErrorResponseModel) {
        emit(ProfileError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProfileLoaded(user: response));
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<HomeState> emit,
  ) async {
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
}
