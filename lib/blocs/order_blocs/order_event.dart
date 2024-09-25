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

class SolutionSelected extends OrderEvent {
  final String selectedSolution;

  const SolutionSelected(this.selectedSolution);

  @override
  List<Object> get props => [selectedSolution];
}

final class DeleteImage extends OrderEvent {
  final int imageIndex;

  const DeleteImage({required this.imageIndex});

  @override
  List<Object> get props => [imageIndex];
}

class ProblemsPop extends OrderEvent {
  const ProblemsPop();

  @override
  List<Object> get props => [];
}

class CameraCapture extends OrderEvent {}

class GalleryImagePicker extends OrderEvent {}

class OrderIsIdle extends OrderEvent {}
