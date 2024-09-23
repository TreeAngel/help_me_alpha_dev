part of 'order_bloc.dart';

class OrderState extends Equatable {
  final ProblemModel? selectedProblem;

  const OrderState({
    this.selectedProblem
  });

  OrderState copyWith({
    ProblemModel? selectedProblem,
  }) {
    return OrderState(selectedProblem: selectedProblem ?? this.selectedProblem);
  }
  
  @override
  List<Object?> get props => [selectedProblem];
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
  List<Object> get props => [errorMessage];
}
