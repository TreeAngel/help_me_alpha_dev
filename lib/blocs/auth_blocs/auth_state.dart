import 'package:help_me_client_alpha_ver/models/api_error_response/message_error_model.dart';
import 'package:image_picker/image_picker.dart';

import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String? fullName;
  final String username;
  final String? phoneNumber;
  final String password;
  final String? passwordConfirmation;
  final String? role;
  final XFile? profilePicture;
  final String? email;
  final bool isPasswordVisible;
  final bool rememberMe;

  const AuthState({
    this.fullName = '',
    this.username = '',
    this.phoneNumber = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.role = 'user',
    this.profilePicture,
    this.email,
    this.isPasswordVisible = false,
    this.rememberMe = false,
  });

  AuthState copyWith({
    String? fullName,
    String? username,
    String? password,
    String? phoneNumber,
    String? passwordConfirmation,
    XFile? profilePicture,
    String? email,
    bool? isPasswordVisible,
    bool? rememberMe,
  }) {
    return AuthState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        username,
        password,
        phoneNumber,
        passwordConfirmation,
        profilePicture,
        email,
        isPasswordVisible,
        rememberMe
      ];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final MessageErrorModel errorMessage;

  const AuthError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Sign In states

final class SignInLoaded extends AuthState {
  final String message;
  final String token;

  const SignInLoaded({required this.message, required this.token});

  @override
  List<Object> get props => [message, token];
}

// Sign Up states

// TODO: Change the response in the future
final class SignUpLoaded extends AuthState {
  final String message;
  final String token;

  const SignUpLoaded({required this.message, required this.token});

  @override
  List<Object> get props => [message, token];
}

// Sign Out states

final class SignOutLoaded extends AuthState {
  final String message;

  const SignOutLoaded({required this.message});

  @override
  List<Object> get props => [message];
}
