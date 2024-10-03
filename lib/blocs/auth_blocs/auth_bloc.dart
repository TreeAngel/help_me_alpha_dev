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

  var fullName = '';
  var username = '';
  var password = '';
  var passwordConfirmation = '';
  var phoneNumber = '';
  final role = 'mitra';
  XFile? profilePicture;
  var isPasswordVisible = false;
  var rememberMe = false;

  var mitraName = '';
  var location = '';
  var mitraType = '';

  AuthBloc({required this.apiController}) : super(const AuthState()) {
    on<FullNameChanged>((event, emit) {
      fullName = event.fullName;
      emit(state.copyWith(fullName: event.fullName));
    });

    on<UsernameChanged>((event, emit) {
      username = event.username;
      emit(state.copyWith(username: event.username));
    });

    on<PhoneNumberChanged>((event, emit) {
      phoneNumber = event.phoneNumber;
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });

    on<PasswordChanged>((event, emit) {
      password = event.password;
      emit(state.copyWith(password: event.password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      passwordConfirmation = event.confirmPassword;
      emit(state.copyWith(passwordConfirmation: event.confirmPassword));
    });

    on<ProfileImageChanged>((event, emit) {
      profilePicture = event.image;
      emit(state.copyWith(profilePicture: event.image));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    on<ToggleRememberMe>((event, emit) {
      rememberMe = !state.rememberMe;
      emit(state.copyWith(rememberMe: !state.rememberMe));
    });

    on<SignInSubmitted>(_onSignInSubmitted);

    on<SignOutSubmitted>(_onSignOutSubmitted);

    on<SignUpSubmitted>(_onSignUpSubmitted);

    on<ResetAuthState>((event, emit) {
      // fullName = '';
      // username = '';
      // password = '';
      // passwordConfirmation = '';
      // phoneNumber = '';
      // profilePicture = null;
      emit(AuthInitial());
    });

    // on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);

  }

  Future<void> _onSignOutSubmitted(
    SignOutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final signOutResponse = await ApiHelper.authLogout();
    if (signOutResponse.error != null) {
      emit(SignOutLoaded(message: signOutResponse.error!.message.toString()));
    } else {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Unknown error occured'),
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

  // Future<void> _onForgotPasswordSubmitted(
  //   ForgotPasswordSubmitted event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   try {
  //     if (event.email.isEmpty || !EmailValidator.validate(event.email)) {
  //       emit(
  //         const AuthError(
  //           errorMessage: MessageErrorModel(message: 'Email tidak valid'),
  //         ),
  //       );
  //     } else {
  //       emit(AuthLoading());

  //       // Panggil API untuk reset password
  //       final forgotPasswordResponse = await ApiHelper.authForgotPassword(event.email);

  //       if (forgotPasswordResponse is AuthResponseModel) {
  //         final message = forgotPasswordResponse.message.toString();
  //         emit(ForgotPasswordLoaded(message: message));
  //       } else if (forgotPasswordResponse is ApiErrorResponseModel) {
  //         final error = forgotPasswordResponse.error;
  //         if (error != null) {
  //           emit(AuthError(errorMessage: error));
  //         } else {
  //           emit(
  //             const AuthError(
  //               errorMessage: MessageErrorModel(message: 'Unknown error occured'),
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     emit(
  //       AuthError(
  //         errorMessage: MessageErrorModel(message: 'An unexpected error occurred: $e'),
  //       ),
  //     );
  //   }
  // }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (fullName.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty ||
        phoneNumber.isEmpty ||
        password.length < 8 ||
        passwordConfirmation != password) {
      emit(
        const AuthError(
          errorMessage:
              MessageErrorModel(message: 'Isi semua data dengan benar'),
        ),
      );
    } else {
      fullName = fullName.trim();
      username = username.trim();
      password = password.trim();
      passwordConfirmation = passwordConfirmation.trim();
      phoneNumber = '+62${phoneNumber.trim()}';
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
          rememberMe == true ? ManageAuthToken.writeToken() : null;
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
