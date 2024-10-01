import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/user_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/api/api_helper.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiController apiController;

  ProfileBloc({required this.apiController}) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);

    on<ProfileIsIdle>((event, emit) => emit(ProfileIdle()));

    on<EditProfile>(_onEditProfile);
  }

  FutureOr<void> _onEditProfile(event, emit) async {
    emit(ProfileLoading());
    if (event.fullname.isEmpty) {
      emit(
        const ProfileError(errorMessage: 'Isi nama lengkap'),
      );
    } else if (event.username.isEmpty) {
      emit(const ProfileError(errorMessage: 'Isi username'));
    } else if (event.phoneNumber.isEmpty) {
      emit(
        const ProfileError(errorMessage: 'Isi nomor telpon'),
      );
    } else if (!event.phoneNumber.startsWith('08')) {
      emit(
        const ProfileError(
            errorMessage: 'isi dengan nomor telpon yang valid'),
      );
    }
    MultipartFile? profileImage;
    if (event.imageProfile != null) {
      profileImage = await MultipartFile.fromFile(
        event.imageProfile!.path,
        filename: event.imageProfile!.name.split('/').last,
      );
    }
    final formData = FormData.fromMap({
      'full_name': event.fullname,
      'username': event.username,
      'phone_number': event.phoneNumber,
      if (profileImage != null) 'image_profile': profileImage,
    });
    final response = await ApiHelper.editProfile(formData);
    if (response is ApiErrorResponseModel) {
      emit(ProfileError(errorMessage: response.error!.message.toString()));
    } else {
      emit(ProfileEdited(message: response.message, data: response.user));
    }
  }

  FutureOr<void> _onFetchProfile(event, emit) async {
    emit(ProfileLoading());
    try {
      final response = await ApiHelper.getUseProfile();
      if (response is ApiErrorResponseModel) {
        emit(ProfileError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProfileLoaded(data: response));
      }
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }
}
