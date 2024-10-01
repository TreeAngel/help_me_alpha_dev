part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class FetchProblems extends OrderEvent {
  final String problemName;

  const FetchProblems({required this.problemName});

  @override
  List<Object> get props => [problemName];
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

class DeleteImage extends OrderEvent {
  final int imageIndex;

  const DeleteImage({required this.imageIndex});

  @override
  List<Object> get props => [imageIndex];
}

class ProblemsPop extends OrderEvent {}

class CameraCapture extends OrderEvent {}

class GalleryImagePicker extends OrderEvent {}

class ShareLocation extends OrderEvent {
  final double lat;
  final double long;

  const ShareLocation({required this.lat, required this.long});

  @override
  List<Object> get props => [lat, long];
}

class OrderIsIdle extends OrderEvent {}

class OrderSubmitted extends OrderEvent {
  final String problem;

  const OrderSubmitted(this.problem);

  @override
  List<Object> get props => [problem];
}
