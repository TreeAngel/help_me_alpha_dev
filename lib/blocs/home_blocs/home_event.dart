part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchCategories extends HomeEvent {}

class FetchProfile extends HomeEvent {}
