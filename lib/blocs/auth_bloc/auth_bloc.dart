import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/api_error_response/message_error_model.dart';
import '../../models/auth_response_model.dart';
import '../../models/login_model.dart';
import '../../services/api/api_controller.dart';
import '../../utils/manage_auth_token.dart';
import '../../models/register_model.dart';
import '../../services/api/api_helper.dart';

import 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiController apiController;

  String fullName = '';
  String username = '';
  String password = '';
  String passwordConfirmation = '';
  String phoneNumber = '';
  final role = 'client';
  XFile? profilePicture;
  bool isPasswordVisible = false;
  bool rememberMe = false;

  AuthBloc({required this.apiController}) : super(const AuthState()) {
    on<FullNameChanged>((event, emit) {
      fullName = event.fullName.trim();
      emit(state.copyWith(fullName: fullName));
    });

    on<UsernameChanged>((event, emit) {
      username = event.username.trim();
      emit(state.copyWith(username: username));
    });

    on<PhoneNumberChanged>((event, emit) {
      phoneNumber = event.phoneNumber.trim();
      emit(state.copyWith(phoneNumber: phoneNumber));
    });

    on<PasswordChanged>((event, emit) {
      password = event.password.trim();
      emit(state.copyWith(password: password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      passwordConfirmation = event.confirmPassword.trim();
      emit(state.copyWith(passwordConfirmation: passwordConfirmation));
    });

    on<ProfileImageChanged>((event, emit) {
      profilePicture = event.image;
      emit(state.copyWith(profilePicture: profilePicture));
    });

    on<TogglePasswordVisibility>((event, emit) {
      isPasswordVisible = !state.isPasswordVisible;
      emit(state.copyWith(isPasswordVisible: isPasswordVisible));
    });

    on<ToggleRememberMe>((event, emit) {
      rememberMe = !state.rememberMe;
      emit(state.copyWith(rememberMe: rememberMe));
    });

    on<SignInSubmitted>(_onSignInSubmitted);

    on<SignOutSubmitted>(_onSignOutSubmitted);

    on<SignUpSubmitted>(_onSignUpSubmitted);

    on<RetryAuthState>((event, emit) {
      // emit(state.copyWith(
      //   fullName: fullName,
      //   phoneNumber: phoneNumber,
      //   username: username,
      //   password: password,
      //   passwordConfirmation: passwordConfirmation,
      //   profilePicture: profilePicture,
      //   isPasswordVisible: isPasswordVisible,
      //   rememberMe: rememberMe,
      // ));
      emit(AuthInitial());
    });

    on<ResetAuthState>((event, emit) {
      fullName = '';
      username = '';
      password = '';
      passwordConfirmation = '';
      phoneNumber = '';
      isPasswordVisible = false;
      rememberMe = false;
      emit(state.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        profilePicture: profilePicture,
        isPasswordVisible: isPasswordVisible,
        rememberMe: rememberMe,
      ));
    });
  }

  Future<void> _onSignOutSubmitted(
    SignOutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final signOutResponse = await ApiHelper.authLogout();
    if (signOutResponse.error != null) {
      final message = signOutResponse.error?.message ?? signOutResponse.error?.error;
        emit(SignOutLoaded(
          message: message.toString(),
        ));
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
    // username = state.username;
    // password = state.password;
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
      final loginModel = LoginModel(
        username: username,
        password: password,
      );
      final signInResponse = await ApiHelper.authLogin(loginModel);
      if (signInResponse is AuthResponseModel) {
        final authMessage = signInResponse.message.toString();
        final authToken = signInResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          rememberMe == true ? ManageAuthToken.writeToken() : null;
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
    // fullName = state.fullName;
    // username = state.username;
    // password = state.password;
    // passwordConfirmation = state.passwordConfirmation;
    // phoneNumber = state.phoneNumber;
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
      final signUpModel = RegisterModel(
        fullName: fullName,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        role: role,
      );
      final signUpResponse = await ApiHelper.authRegister(signUpModel);
      if (signUpResponse is AuthResponseModel) {
        final authMessage = signUpResponse.message.toString();
        final authToken = signUpResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
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
