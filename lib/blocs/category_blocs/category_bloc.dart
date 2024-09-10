import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/models/category_model.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';

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
      final categories = await ApiHelper.getCategories();
      emit(CategoryLoaded(categories: categories.data));
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }
}
