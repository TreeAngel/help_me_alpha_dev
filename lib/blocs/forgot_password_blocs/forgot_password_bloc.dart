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
        data: {'phone_number': event.phoneNumber},
      );
      print(response); // Log response to check what's coming back


      if (response is! ApiErrorResponseModel) {
        emit(ForgotPasswordSuccess());
      } else if (response is ApiErrorResponseModel) {
        final errorMessage = response.error?.message ?? 'API error occurred, please try again';
        // print('Error message from API: $errorMessage'); // Log the error message
        emit(ForgotPasswordError(errorMessage));
      } else {
        emit(ForgotPasswordError('Unknown error occurred'));
      }
    } catch (e) {
  // Print detailed exception information
      // print('DioException: $e');
      if (e is DioException && e.response != null) {
        final errorData = e.response?.data;
        // print('Error Data: $errorData'); // Log detailed error data from Dio response
        final errorMessage = errorData is Map<String, dynamic> && errorData['message'] != null
          ? errorData['message']
          : 'An unknown error occurred';
        emit(ForgotPasswordError(errorMessage));
      } else {
        emit(ForgotPasswordError(e.toString()));
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