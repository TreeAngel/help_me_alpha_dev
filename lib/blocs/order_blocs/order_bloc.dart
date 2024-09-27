import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/order_request_model.dart';
import '../../models/order_response_model/order_model.dart';
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
  late double? lat;
  late double? long;
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
      lat = null;
      long = null;
      emit(OrderInitial());
    });

    on<CameraCapture>((event, emit) async {
      XFile? file = await imagePickerUtil.cameraCapture();
      problemPictures.add(file);
      emit(ImagePicked(pickedImage: file));
    });

    on<GalleryImagePicker>((event, emit) async {
      XFile? file = await imagePickerUtil.imageFromGallery();
      problemPictures.add(file);
      emit(ImagePicked(pickedImage: file));
    });

    on<DeleteImage>((event, emit) {
      problemPictures.removeAt(event.imageIndex);
      emit(ImageDeleted(imageIndex: event.imageIndex));
    });

    on<OrderIsIdle>((event, emit) => emit(OrderIdle()));

    on<OrderSubmitted>(_orderSubmitted);

    on<ShareLocation>((event, emit) {
      lat = event.lat;
      long = event.long;
    });
  }

  _orderSubmitted(event, emit) async {
    emit(OrderLoading());
    if (selectedProblem != null && selectedSolution != null && lat != null && long != null) {
      if (selectedSolution!.isNotEmpty) {
        List<MultipartFile> images = [];
        if (problemPictures.isNotEmpty) {
          for (XFile? file in problemPictures) {
            if (file != null) {
              images.add(
                await MultipartFile.fromFile(
                  file.path,
                  filename: file.name,
                  contentType: DioMediaType.parse('image'),
                ),
              );
            }
          }
        }
        final orderRequest = OrderRequestModel(
          problemId: selectedProblem?.id,
          description: selectedSolution,
          attachments: images,
          lat: lat!,
          long: long!,
        );
        final response = await ApiHelper.postOrder(orderRequest);
        if (response is ApiErrorResponseModel) {
          emit(OrderError(errorMessage: response.error!.error.toString()));
        } else {
          emit(OrderUploaded(message: response.message, order: response.order));
        }
      }
    } else {
      emit(const OrderError(errorMessage: 'Isi semua data yang diperlukan'));
    }
  }

  _onFetchProblems(
    FetchProblems event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final response = await ApiHelper.getProblems(event.problemName);
      if (response is ApiErrorResponseModel) {
        emit(OrderError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProblemsLoaded(problems: response));
      }
    } catch (e) {
      emit(OrderError(errorMessage: e.toString()));
    }
  }
}
