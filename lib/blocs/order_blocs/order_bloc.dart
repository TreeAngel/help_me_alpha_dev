import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/problem_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/api/api_helper.dart';
import '../../utils/image_picker_util.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiController apiController;
  final ImagePickerUtil imagePickerUtil;

  late ProblemModel? selectedProblem;
  late String? selectedSolution;
  List<XFile?> problemPictures = [];

  OrderBloc({required this.apiController, required this.imagePickerUtil})
      : super(OrderInitial()) {
    on<FetchProblems>(_onFetchProblems);

    on<ProblemSelected>((event, emit) {
      selectedProblem = event.selectedProblem;
    });

    on<SolutionSelected>((event, emit) {
      selectedSolution = event.selectedSolution;
    });

    on<ProblemsPop>((event, emit) {
      selectedProblem = null;
      selectedSolution = null;
      problemPictures.clear();
      emit(OrderInitial());
    });

    on<CameraCapture>((event, emit) async {
      XFile? file = await imagePickerUtil.cameraCapture();
      problemPictures.add(file);
      state.copyWith(pictures: problemPictures);
      emit(ImagePicked(pickedImage: file));
    });

    on<GalleryImagePicker>((event, emit) async {
      XFile? file = await imagePickerUtil.imageFromGallery();
      problemPictures.add(file);
      state.copyWith(pictures: problemPictures);
      emit(ImagePicked(pickedImage: file));
    });

    on<DeleteImage>((event, emit) {
      problemPictures.removeAt(event.imageIndex);
      state.copyWith(pictures: problemPictures);
      emit(ImageDeleted(imageIndex: event.imageIndex));
    });

    on<OrderIsIdle>((event, emit) => emit(OrderIdle()));
  }

  _onFetchProblems(
    FetchProblems event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final response = await ApiHelper.getProblems(event.id);
      if (response is ApiErrorResponseModel) {
        emit(ProblemsError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProblemsLoaded(problems: response.data));
      }
    } catch (e) {
      emit(ProblemsError(errorMessage: e.toString()));
    }
  }
}
