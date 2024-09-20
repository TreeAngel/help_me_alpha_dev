part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();
  
  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class ProblemsLoaded extends OrderState {
  final List<ProblemModel> problems;

  const ProblemsLoaded({required this.problems});

  @override
  List<Object> get props => [problems];
}

final class ProblemsError extends OrderState {
  final String errorMessage;

  const ProblemsError({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object> get props => [errorMessage];
}


