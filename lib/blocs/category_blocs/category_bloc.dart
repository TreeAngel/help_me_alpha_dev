import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/models/category_model.dart';
import 'package:help_me_client_alpha_ver/services/api/api_helper.dart';

import '../../models/api_error_response/api_error_response_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiHelper apiHelper;

  CategoryBloc({required this.apiHelper}) : super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
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
