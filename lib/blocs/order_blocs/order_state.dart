part of 'order_bloc.dart';

class OrderState extends Equatable {
  final ProblemModel? selectedProblem;
  final String? selectedSolution;
  final List<XFile?>? pictures;

  const OrderState({
    this.selectedProblem,
    this.selectedSolution,
    this.pictures,
  });

  OrderState copyWith(
      {ProblemModel? selectedProblem,
      String? selectedSolution,
      List<XFile?>? pictures}) {
    return OrderState(
      selectedProblem: selectedProblem ?? this.selectedProblem,
      selectedSolution: selectedSolution ?? this.selectedSolution,
      pictures: pictures ?? this.pictures,
    );
  }

  @override
  List<Object?> get props => [selectedProblem, selectedSolution, pictures];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderIdle extends OrderState {}

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

final class ImagePicked extends OrderState {
  final XFile? pickedImage;

  const ImagePicked({required this.pickedImage});

  @override
  List<Object?> get props => [pickedImage];
}

final class ImageDeleted extends OrderState {
  final int imageIndex;

   const ImageDeleted({required this.imageIndex});

  @override
  List<Object?> get props => [imageIndex];
}
