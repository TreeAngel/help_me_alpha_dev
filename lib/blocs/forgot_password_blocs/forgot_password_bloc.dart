import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_mitra_alpha_ver/models/api_error_response/api_error_response_model.dart';
import 'package:help_me_mitra_alpha_ver/services/api/api_controller.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';
import 'package:dio/dio.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await ApiController.postData(
        'auth/forgot-password',
        {'phone_number': event.phoneNumber},
      );
      print(response);


    if (response is! ApiErrorResponseModel) {
      emit(ForgotPasswordSuccess());
    } else {
      // Periksa apakah error message null atau tidak
      final errorMessage = response.error?.message ?? response.message ?? 'API error occurred, please try again';
      emit(ForgotPasswordError(errorMessage, ForgotPasswordErrorType.unknown));
    }

    } catch (e) {
      if (e is DioException && e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;

        if (statusCode == 422) {
          final errorMessage = errorData['message'] ?? 'Nomor telepon belum diverifikasi';

          if (errorMessage == 'Nomor telepon belum diverifikasi') {
            emit(ForgotPasswordPhoneNotVerified());
          } else {
            emit(ForgotPasswordError(errorMessage, ForgotPasswordErrorType.phoneNotVerified));
          }
        } else if (statusCode == 500) {
          emit(ForgotPasswordError('Server error, please try again later', ForgotPasswordErrorType.unknown));
        } else {
          final errorMessage = errorData['message'] ?? 'API error occurred, please try again';
          emit(ForgotPasswordError(errorMessage, ForgotPasswordErrorType.unknown));
        }
      }

    }
  }
}

  // Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
  //   if(event is ForgotPasswordSubmitted){
  //     yield ForgotPasswordLoading();
  //     try{
  //       final response = await ApiController.postData(
  //         'auth/forgot-password',
  //         data: {'phone': event.phoneNumber},
  //       );

  //       if (response.statusCode == 200) {
  //         yield ForgotPasswordSuccess();
  //       }else{
  //         yield const ForgotPasswordError('Failed to send reset link');
  //       }
  //     }catch(e){
  //       yield ForgotPasswordError(e.toString());
  //     }
  //   }
  // }
// }