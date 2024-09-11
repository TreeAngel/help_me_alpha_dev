import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/models/login_model.dart';
import 'package:help_me_client_alpha_ver/services/api_helper.dart';
import 'package:help_me_client_alpha_ver/utils/secure_storage.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final ApiHelper apiHelper;

  var username = '';
  var password = '';
  var rememberMe = false;

  SignInBloc({required this.apiHelper}) : super(const SignInState()) {
    on<UsernameChanged>((event, emit) {
      username = event.username;
      emit(state.copyWith(username: event.username));
    });

    on<PasswordChanged>((event, emit) {
      password = event.password;
      emit(state.copyWith(password: event.password));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<ToggleRememberMe>((event, emit) {
      rememberMe = !state.isRememberMe;
      emit(state.copyWith(isRememberMe: !state.isRememberMe));
    });

    on<SignInSubmitted>(_onSignInSubmitted);

    on<ResetSignInState>((event, emit) {
      emit(SignInInitial());
    });
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      emit(const SignInError(
          errorMessage: 'Username atau password tidak boleh kosong'));
    } else if (password.length < 8) {
      emit(const SignInError(
          errorMessage: 'Password harus lebih dari 8 karakter'));
    } else {
      emit(SignInLoading());
      try {
        final loginModel = LoginModel(
          username: username,
          password: password,
        );
        final authResponse = await ApiHelper.authLogin(loginModel);
        final authMessage = authResponse.message.toString();
        final authToken = authResponse.token;
        if (authToken != null) {
          ApiHelper.token = authToken;
          emit(
            SignInLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
          rememberMe == true
              ? SecureStorage().writeSecureData('authToken', authToken)
              : null;
        } else {
          emit(SignInError(errorMessage: authMessage));
        }
      } catch (e) {
        if (e is DioException) {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
              emit(const SignInError(
                  errorMessage:
                      'Connection timeout, try again after a few seconds'));
              break;
            case DioExceptionType.receiveTimeout:
              emit(const SignInError(
                  errorMessage:
                      'Failed to receive data, try again after a few seconds'));
              break;
            case DioExceptionType.sendTimeout:
              emit(const SignInError(
                  errorMessage:
                      'Failed to send data, try again after a few seconds'));
              break;
            case DioExceptionType.badCertificate:
              emit(const SignInError(
                  errorMessage:
                      'Failed to validate certificate, try again after a few seconds'));
              break;
            case DioExceptionType.badResponse:
              emit(const SignInError(
                  errorMessage:
                      'Failed to process data, try again after a few seconds'));
              break;
            case DioExceptionType.cancel:
              emit(const SignInError(
                  errorMessage:
                      'Network request was cancelled, try again after a few seconds'));
              break;
            case DioExceptionType.connectionError:
              emit(const SignInError(
                  errorMessage:
                      'Connection error, try again after a few seconds'));
              break;
            case DioExceptionType.unknown:
              emit(const SignInError(
                  errorMessage:
                      'An error occurred, try again after a few seconds'));
              break;
          }
        } else {
          emit(SignInError(
              errorMessage: 'Unknown error:\n$e'));
        }
      }
    }
  }
}
