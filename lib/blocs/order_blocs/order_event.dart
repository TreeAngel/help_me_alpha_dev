part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchProblems extends OrderEvent {
  final int id;

  const FetchProblems({required this.id});

  @override
  List<Object> get props => [id];
}

class ProblemSelected extends OrderEvent {
  final ProblemModel selectedProblem;

  const ProblemSelected(this.selectedProblem);

  @override
  List<Object> get props => [selectedProblem];
}

class ProblemsPop extends OrderEvent {
  const ProblemsPop();

  @override
  List<Object> get props => [];
}
