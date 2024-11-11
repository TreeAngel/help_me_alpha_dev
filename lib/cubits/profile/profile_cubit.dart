import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/auth/user_mitra_model.dart';
import '../../models/auth/user_model.dart';
import '../../models/category_problem/category_model.dart';
import '../../services/api/api_helper.dart';
import '../../ui/pages/auth/verify_phone_number_page.dart';
import '../../ui/pages/profile/profile_page.dart';
import '../../utils/image_picker_util.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ImagePickerUtil imagePickerUtil;

  ProfileCubit({required this.imagePickerUtil}) : super(ProfileInitial());

  UserModel? userProfile;
  UserMitraModel? userMitra;

  // Variable for edit user profile
  String? oldPassword;
  String? newPassword;
  String? newConfirmPassword;

  String? fullname;
  String? username;
  String? phoneNumber;
  XFile? imageProfile;

  // Variable for edit mitra profile
  String? mitraName;
  GeoPoint? mitraLocation;
  List<CategoryModel> helpers = [];

  // Variable for otp
  String? codeOTP;
  StatusOTP statusOTP = StatusOTP.waiting;

  void profileInit() => emit(ProfileInitial());

  void profileIsIdle() => emit(ProfileIdle());

  void profileDisposed() {
    userProfile = null;
    userMitra = null;
    oldPassword = null;
    newPassword = null;
    newConfirmPassword = null;
    fullname = null;
    username = null;
    phoneNumber = null;
    imageProfile = null;
    mitraName = null;
    mitraLocation = null;
    if (helpers.isNotEmpty) helpers.clear();
    codeOTP = null;
    statusOTP = StatusOTP.waiting;
    emit(ProfileDisposed());
  }

  void changeSegment(ProfileSegment segment) => emit(
        ProfileSegmentChanged(segment: segment),
      );

  void helperAdded(CategoryModel helper) {
    if (!helpers.contains(helper)) {
      helpers.add(helper);
      log(helpers.join(', '), name: 'tambah helper');
      emit(HelpersChanged(helper: helper));
    }
  }

  void helperRemoved(CategoryModel helper) {
    if (helpers.contains(helper)) {
      helpers.remove(helper);
      log(helpers.join(', '), name: 'hapus helper');
      emit(HelpersChanged(helper: helper));
    }
  }

  void mitraLocationUpdated(GeoPoint location) => {
        log(mitraLocation.toString(), name: 'Old location'),
        mitraLocation = location,
        log(mitraLocation.toString(), name: 'New location'),
        emit(MitraLocationUpdated(newLocation: location)),
      };

  FutureOr<void> verifyOTP() async {
    emit(OTPLoading());
    if (codeOTP == null || codeOTP!.isEmpty) {
      emit(
        const ProfileError(errorMessage: 'Isi dengan kode OTP'),
      );
    } else {
      final response = await ApiHelper.verifyOTP(phoneNumber!, codeOTP!);
      if (response.error != null) {
        final message = response.error?.message ?? response.error?.error;
        emit(OTPVerified(
          message: message.toString(),
        ));
      } else {
        emit(const OTPError(errorMessage: 'Unknown error occured'));
      }
    }
  }

  FutureOr<void> requestOTP() async {
    emit(OTPLoading());
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      emit(
        const OTPError(errorMessage: 'Isi nomor telpon'),
      );
    } else if (!phoneNumber!.startsWith('08')) {
      emit(
        const OTPError(errorMessage: 'Isi dengan nomor telpon yang valid'),
      );
    } else {
      final response = await ApiHelper.requestOTP(phoneNumber!);
      if (response.error != null) {
        final message = response.error?.message ?? response.error?.error;
        emit(OTPRequested(
          message: message.toString(),
        ));
      } else {
        emit(const OTPError(errorMessage: 'Unknown error occured'));
      }
    }
  }

  FutureOr<void> galleryImagePicker() async {
    XFile? imagePicked = await imagePickerUtil.imageFromGallery();
    if (imagePicked != null) {
      imageProfile = imagePicked;
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(ProfileIdle());
    }
  }

  FutureOr<void> cameraCapture() async {
    XFile? imagePicked = await imagePickerUtil.cameraCapture();
    if (imagePicked != null) {
      imageProfile = imagePicked;
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(ProfileIdle());
    }
  }

  FutureOr<void> editPasswordSubmitted() async {
    emit(ProfileLoading());
    if (oldPassword == null || oldPassword!.isEmpty) {
      emit(const EditPasswordError(errorMessage: 'Isi kata sandi lama'));
    } else if (oldPassword!.length < 8) {
      emit(const EditPasswordError(
          errorMessage: 'Kata sandi lama minimal 8 karakter'));
    } else if (newPassword == null || newPassword!.isEmpty) {
      emit(const EditPasswordError(errorMessage: 'Isi kata sandi baru'));
    } else if (newPassword!.length < 8) {
      emit(const EditPasswordError(
          errorMessage: 'Kata sandi baru minimal 8 karakter'));
    } else if (newConfirmPassword == null ||
        newConfirmPassword != newPassword) {
      emit(const EditPasswordError(errorMessage: 'Konfirmasi kata sandi baru'));
    } else {
      final response = await ApiHelper.changePassword(
          oldPassword!, newPassword!, newConfirmPassword!);
      if (response.error != null) {
        final message = response.error?.message ?? response.error?.error;
        emit(EditPasswordLoaded(
          message: message.toString(),
        ));
      } else {
        emit(const EditPasswordError(errorMessage: 'Unknown error occured'));
      }
    }
  }

  FutureOr<void> editMitraProfile() async {
    emit(ProfileLoading());
    if (mitraName == null || mitraName!.isEmpty) {
      emit(const EditProfileError(message: 'Isi nama usaha'));
    } else if (mitraLocation == null) {
      emit(const EditProfileError(message: 'Isi lokasi usaha'));
    } else if (helpers.isEmpty) {
      emit(const EditProfileError(message: 'Isi spesialisasi usaha anda'));
    } else {
      List<int> helperIds = [];
      for (var helper in helpers) {
        helperIds.add(helper.id);
      }
      final formData = FormData.fromMap({
        'name': mitraName,
        'latitude': mitraLocation!.latitude,
        'longitude': mitraLocation!.longitude,
        'helper_ids[]': helperIds
      });
      final response = await ApiHelper.editMitraProfie(
        mitraId: userMitra!.id!,
        request: formData,
      );
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.message ?? response.error?.error;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(EditProfileError(message: message.toString()));
      } else {
        emit(MitraProfileEdited(
          message: response.message,
          data: response.mitra,
        ));
      }
    }
  }

  FutureOr<void> editUserProfile() async {
    emit(ProfileLoading());
    if (fullname == null || fullname!.isEmpty) {
      emit(const EditProfileError(message: 'Isi nama lengkap'));
    } else if (fullname == null || username!.isEmpty) {
      emit(const EditProfileError(message: 'Isi username'));
    } else if (phoneNumber == null || phoneNumber!.isEmpty) {
      emit(
        const EditProfileError(message: 'Isi nomor telpon'),
      );
    } else if (!phoneNumber!.startsWith('08')) {
      emit(
        const EditProfileError(message: 'isi dengan nomor telpon yang valid'),
      );
    } else {
      MultipartFile? profileImage;
      if (imageProfile != null) {
        profileImage = await MultipartFile.fromFile(
          imageProfile!.path,
          filename: imageProfile!.name.split('/').last,
        );
      }
      final formData = FormData.fromMap({
        'full_name': fullname,
        'username': username,
        'phone_number': phoneNumber,
        if (profileImage != null) 'image_profile': profileImage,
      });
      final response = await ApiHelper.editUserProfile(formData);
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.message ?? response.error?.error;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(EditProfileError(message: message.toString()));
      } else {
        emit(UserProfileEdited(message: response.message, data: response.user));
      }
    }
  }

  FutureOr<void> fetchProfile() async {
    emit(ProfileLoading());
    final response = await ApiHelper.getUserProfile();
    if (response is ApiErrorResponseModel) {
      String? message = response.error?.message ?? response.error?.error;
      if (message == null || message.isEmpty) {
        message = response.toString();
      }
      emit(ProfileError(errorMessage: message.toString()));
    } else {
      emit(ProfileLoaded(userProfile: response));
    }
  }

  Future<void> fetchMitra() async {
    emit(ProfileLoading());
    final response = await ApiHelper.getUserMitra();
    if (response is ApiErrorResponseModel) {
      String? message = response.error?.error ?? response.error?.message;
      if (message == null || message.isEmpty) {
        message = response.toString();
      }
      emit(ProfileError(errorMessage: message));
    } else {
      emit(MitraLoaded(mitra: response));
    }
  }
}
