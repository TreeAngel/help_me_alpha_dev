part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CategoryError extends CategoryState {
  final String errorMessage;

  const CategoryError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
