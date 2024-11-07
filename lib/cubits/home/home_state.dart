part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeIdle extends HomeState {}

final class HomeDispose extends HomeState {}

final class HomeLoading extends HomeState {}

final class CategoryLoaded extends HomeState {
  final List<CategoryModel> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CategoryError extends HomeState {
  final String errorMessage;

  const CategoryError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class HelperLoaded extends HomeState {
  final List<CategoryModel> helpers;

  const HelperLoaded({required this.helpers});

  @override
  List<Object> get props => [helpers];
}

final class HelperError extends HomeState {
  final String message;

  const HelperError({required this.message});

  @override
  List<Object> get props => [message];
}

final class OrderHistoryLoaded extends HomeState {
  final List<OrderHistoryModel> histories;

  const OrderHistoryLoaded({required this.histories});

  @override
  List<Object> get props => [histories];
}

final class OrderHistoryError extends HomeState {
  final String message;

  const OrderHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
