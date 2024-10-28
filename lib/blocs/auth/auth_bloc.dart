import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';
import '../../models/auth/auth_response_model.dart';
import '../../models/auth/login_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/firebase/firebase_api.dart';
import '../../utils/manage_token.dart';
import '../../models/auth/register_model.dart';
import '../../services/api/api_helper.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String fullName = '';
  String username = '';
  String password = '';
  String passwordConfirmation = '';
  String phoneNumber = '';
  final role = 'client';
  bool isPasswordVisible = false;
  bool rememberMe = false;

  AuthBloc() : super(AuthInitial()) {
    on<FullNameChanged>(
      (event, emit) => fullName = event.fullName.trim(),
    );

    on<UsernameChanged>(
      (event, emit) => username = event.username.trim(),
    );

    on<PhoneNumberChanged>(
      (event, emit) => phoneNumber = event.phoneNumber.trim(),
    );

    on<PasswordChanged>((event, emit) => password = event.password.trim());

    on<ConfirmPasswordChanged>(
      (event, emit) => passwordConfirmation = event.confirmPassword.trim(),
    );

    on<TogglePasswordVisibility>((event, emit) {
      isPasswordVisible = !isPasswordVisible;
      emit(PasswordToggled());
    });

    on<ToggleRememberMe>((event, emit) {
      rememberMe = !rememberMe;
      emit(RememberMeToggled());
    });

    on<SignInSubmitted>(_onSignInSubmitted);

    on<SignOutSubmitted>(_onSignOutSubmitted);

    on<SignUpSubmitted>(_onSignUpSubmitted);

    on<ForgetPasswordSubmitted>(_onForgetPasswordSubmitted);

    on<AuthIsIdle>((event, emit) => emit(AuthIdle()));

    on<ResetAuthState>((event, emit) {
      fullName = '';
      username = '';
      password = '';
      passwordConfirmation = '';
      phoneNumber = '';
      isPasswordVisible = false;
      rememberMe = false;
      emit(AuthInitial());
    });
  }

  FutureOr<void> _onForgetPasswordSubmitted(event, emit) async {
    emit(AuthLoading());
    if (phoneNumber.isEmpty) {
      emit(const ForgetPasswordError(message: 'Isi nomor telpon'));
    } else if (!phoneNumber.startsWith('08')) {
      emit(const ForgetPasswordError(
          message: 'Isi dengan nomor telpon yang valid'));
    } else {
      final response = await ApiHelper.forgotPassword(phoneNumber);
      if (response.error != null) {
        var message = response.error?.message ?? response.error?.error;
        message ??= 'Nomor yang anda masukan tidak terdaftar';
        emit(ForgetPasswordLoaded(message: message.toString()));
      } else {
        emit(const ForgetPasswordError(message: 'Unknown error occured'));
      }
    }
  }

  Future<void> _onSignOutSubmitted(
    SignOutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final signOutResponse = await ApiHelper.authLogout();
    if (signOutResponse.error != null) {
      final message =
          signOutResponse.error?.message ?? signOutResponse.error?.error;
      log('Signout: $message');
      if (message!.trim().toLowerCase().contains('unauthorized')) {
        emit(AuthError(
          errorMessage: MessageErrorModel(error: message),
        ));
      } else {
        ApiController.token = null;
        FirebaseMessagingApi.fcmToken = null;
        ManageAuthToken.deleteToken();
        ManageFCMToken.deleteToken();
        emit(SignOutLoaded(
          message: message.toString(),
        ));
      }
    } else {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Unknown error occured',
          ),
        ),
      );
    }
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (username.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Isi username',
          ),
        ),
      );
    } else if (password.length < 8) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(
            message: 'Password minimal 8 karakter',
          ),
        ),
      );
    } else {
      emit(AuthLoading());
      late LoginModel loginRequest;
      String? fcmToken = await ManageFCMToken.readToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FirebaseMessagingApi.getFCMToken();
      }
      loginRequest = LoginModel(
        username: username,
        password: password,
        fcmToken: fcmToken,
      );
      final signInResponse = await ApiHelper.authLogin(loginRequest);
      if (signInResponse is AuthResponseModel) {
        final authMessage = signInResponse.message.toString();
        final authToken = signInResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          FirebaseMessagingApi.fcmToken = fcmToken;
          rememberMe == true
              ? {
                  ManageAuthToken.writeToken(),
                  ManageFCMToken.writeToken(fcmToken),
                }
              : null;
          emit(
            SignInLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signInResponse is ApiErrorResponseModel) {
        final error = signInResponse.error;
        if (error != null) {
          emit(AuthError(errorMessage: error));
        } else {
          emit(
            const AuthError(
              errorMessage: MessageErrorModel(
                message: 'Unknown error occured',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (fullName.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Isi nama lengkap'),
        ),
      );
    } else if (phoneNumber.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Isi nomor telepon'),
        ),
      );
    } else if (!phoneNumber.startsWith('08')) {
      emit(
        const AuthError(
          errorMessage:
              MessageErrorModel(message: 'Isi dengan nomor telpon yang valid'),
        ),
      );
    } else if (username.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Isi username'),
        ),
      );
    } else if (password.isEmpty) {
      emit(
        const AuthError(
          errorMessage:
              MessageErrorModel(message: 'Password minimal 8 karakter'),
        ),
      );
    } else if (passwordConfirmation.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Isi konfirmasi password'),
        ),
      );
    } else if (passwordConfirmation != password) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Konfirmasi password salah'),
        ),
      );
    } else {
      emit(AuthLoading());
      String? fcmToken = await ManageFCMToken.readToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FirebaseMessagingApi.getFCMToken();
      } else {
        emit(
          const AuthError(
            errorMessage: MessageErrorModel(error: 'Gagal memuat FCM token'),
          ),
        );
        return;
      }
      final signUpModel = RegisterModel(
        fullName: fullName,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        role: role,
        fcmToken: fcmToken,
      );
      final signUpResponse = await ApiHelper.authRegister(signUpModel);
      if (signUpResponse is AuthResponseModel) {
        final authMessage = signUpResponse.message.toString();
        final authToken = signUpResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          FirebaseMessagingApi.fcmToken = fcmToken;
          emit(
            SignUpLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signUpResponse is ApiErrorResponseModel) {
        final error = signUpResponse.error;
        if (error != null) {
          emit(AuthError(errorMessage: error));
        } else {
          emit(
            const AuthError(
              errorMessage: MessageErrorModel(message: 'Unknown error occured'),
            ),
          );
        }
      }
    }
  }
}
