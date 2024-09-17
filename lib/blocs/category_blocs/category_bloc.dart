import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_model.dart';
import '../../services/api/api_controller.dart';
import '../../models/api_error_response/api_error_response_model.dart';
import '../../services/api/api_helper.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiController apiHelper;

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
