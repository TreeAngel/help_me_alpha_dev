import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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

    on<ProblemSelected>(
      (event, emit) => selectedProblem = event.selectedProblem,
    );

    on<SolutionSelected>(
      (event, emit) => selectedSolution = event.selectedSolution,
    );

    on<ProblemsPop>((event, emit) {
      selectedProblem = null;
      selectedSolution = null;
      problemPictures.clear();
      lat = null;
      long = null;
      emit(OrderInitial());
    });

    on<CameraCapture>(_onCameraCapture);

    on<GalleryImagePicker>(_onGalleryImagePicker);

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

  FutureOr<void> _onGalleryImagePicker(event, emit) async {
    XFile? imagePicked = await imagePickerUtil.imageFromGallery();
    if (imagePicked != null) {
      problemPictures.add(imagePicked);
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(OrderIdle());
    }
  }

  FutureOr<void> _onCameraCapture(event, emit) async {
    XFile? imagePicked = await imagePickerUtil.cameraCapture();
    if (imagePicked != null) {
      problemPictures.add(imagePicked);
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(OrderIdle());
    }
  }

  _orderSubmitted(event, emit) async {
    emit(OrderLoading());
    if (selectedProblem != null ||
        (event as OrderSubmitted).problem.toLowerCase().contains('serabutan')) {
      if (selectedSolution != null && lat != null && long != null) {
        if (selectedSolution!.isNotEmpty) {
          List<MultipartFile> images = [];
          if (problemPictures.isNotEmpty) {
            for (XFile? file in problemPictures) {
              if (file != null) {
                images.add(
                  await MultipartFile.fromFile(
                    file.path,
                    filename: file.name.split('/').last,
                    contentType: MediaType.parse(
                      lookupMimeType(file.path) ?? 'application/octet-stream',
                    ),
                  ),
                );
              }
            }
          }
          int? id;
          selectedProblem != null ? id = selectedProblem?.id : null;
          final orderRequest = OrderRequestModel(
            problemId: id,
            description: selectedSolution,
            attachments: images,
            lat: lat!,
            long: long!,
          );
          final formData = FormData.fromMap({
            if (id != null) 'problem_id': id,
            'description': orderRequest.description,
            'latitude': orderRequest.lat,
            'longitude': orderRequest.long,
            if (images.isNotEmpty) 'attachments[]': orderRequest.attachments,
          });
          final response = await ApiHelper.postOrder(formData);
          if (response is ApiErrorResponseModel) {
            emit(OrderError(errorMessage: response.error!.message.toString()));
          } else {
            emit(OrderUploaded(
              message: response.message,
              order: response.order,
            ));
          }
        }
      } else {
        emit(const OrderError(errorMessage: 'Isi semua data untuk lanjut!'));
      }
    } else {
      emit(
        const OrderError(
          errorMessage:
              'Terjadi kesalahan pada aplikasi, pilih kembali kategori masalah di halaman home',
        ),
      );
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
