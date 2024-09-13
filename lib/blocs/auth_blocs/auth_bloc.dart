import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/models/api_error_response/api_error_response_model.dart';
import 'package:help_me_client_alpha_ver/models/api_error_response/message_error_model.dart';
import 'package:help_me_client_alpha_ver/models/auth_response_model.dart';
import 'package:help_me_client_alpha_ver/models/login_model.dart';
import 'package:help_me_client_alpha_ver/services/api/api_helper.dart';
import 'package:help_me_client_alpha_ver/utils/manage_auth_token.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/register_model.dart';
import 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiHelper apiHelper;

  var fullName = '';
  var username = '';
  var password = '';
  var passwordConfirmation = '';
  var phoneNumber = '';
  var email = '';
  final role = 'user';
  XFile? profilePicture;
  var isPasswordVisible = false;
  var rememberMe = false;

  AuthBloc({required this.apiHelper}) : super(const AuthState()) {
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

    on<EmailChanged>((event, emit) {
      email = event.email;
      emit(state.copyWith(email: event.email));
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
      fullName = '';
      username = '';
      password = '';
      passwordConfirmation = '';
      phoneNumber = '';
      profilePicture = null;
      email = '';
      emit(AuthInitial());
    });
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
    if (username.isEmpty || password.isEmpty) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Unknown error occured'),
        ),
      );
    } else if (password.length < 8) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Unknown error occured'),
        ),
      );
    } else {
      emit(AuthLoading());
      username = username.trim();
      password = password.trim();
      final loginModel = LoginModel(
        username: username,
        password: password,
      );
      final signInResponse = await ApiHelper.authLogin(loginModel);
      if (signInResponse is AuthResponseModel) {
        final authMessage = signInResponse.message.toString();
        final authToken = signInResponse.token;
        if (authToken != null) {
          ApiHelper.token = authToken;
          emit(
            SignInLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
          rememberMe == true ? ManageAuthToken.writeToken() : null;
        }
      } else if (signInResponse is ApiErrorResponseModel) {
        final error = signInResponse.error;
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
        passwordConfirmation != password ||
        !EmailValidator.validate(email)) {
      emit(
        const AuthError(
          errorMessage: MessageErrorModel(message: 'Isi semua data dengan benar'),
        ),
      );
    } else {
      fullName = fullName.trim();
      username = username.trim();
      password = password.trim();
      passwordConfirmation = passwordConfirmation.trim();
      phoneNumber = '+62${phoneNumber.trim()}';
      email = email.trim();
      emit(AuthLoading());
      final signUpModel = RegisterModel(
        fullName: fullName,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        role: role,
        email: email,
      );
      final signUpResponse = await ApiHelper.authRegister(signUpModel);
      if (signUpResponse is AuthResponseModel) {
        final authMessage = signUpResponse.message.toString();
        final authToken = signUpResponse.token;
        if (authToken != null) {
          ApiHelper.token = authToken;
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
