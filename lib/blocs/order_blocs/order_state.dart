part of 'order_bloc.dart';

class OrderState extends Equatable {
  final ProblemModel? selectedProblem;
  final String? selectedSolution;

  const OrderState({
    this.selectedProblem,
    this.selectedSolution,
  });

  OrderState copyWith(
      {ProblemModel? selectedProblem, String? selectedSolution}) {
    return OrderState(
      selectedProblem: selectedProblem ?? this.selectedProblem,
      selectedSolution: selectedSolution ?? this.selectedSolution,
    );
  }

  @override
  List<Object?> get props => [
        selectedProblem,
        selectedSolution,
      ];
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
