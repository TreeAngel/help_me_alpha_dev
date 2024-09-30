part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderIdle extends OrderState {}

final class OrderError extends OrderState {
  final String errorMessage;

  const OrderError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ProblemsLoaded extends OrderState {
  final List<ProblemModel> problems;

  const ProblemsLoaded({required this.problems});

  @override
  List<Object> get props => [problems];
}

final class LocationShared extends OrderState {}

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

final class OrderUploaded extends OrderState {
  final String message;
  final OrderModel order;

  const OrderUploaded({
    required this.message,
    required this.order,
  });

  @override
  List<Object?> get props => [message, order];
}
