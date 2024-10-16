import 'package:image_picker/image_picker.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/message_error_model.dart';

class AuthState extends Equatable {
  final String? fcmToken;
  final String? fullName;
  final String username;
  final String? phoneNumber;
  final String password;
  final String? passwordConfirmation;
  final String? role;
  final XFile? profilePicture;
  final bool isPasswordVisible;
  final bool rememberMe;
  final String mitraType;

  const AuthState({
    this.fcmToken = '',
    this.fullName = '',
    this.username = '',
    this.phoneNumber = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.role = 'mitra',
    this.profilePicture,
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.mitraType = '',
  });

  AuthState copyWith({
    String? fcmToken,
    String? fullName,
    String? username,
    String? password,
    String? phoneNumber,
    String? passwordConfirmation,
    XFile? profilePicture,
    bool? isPasswordVisible,
    bool? rememberMe,
    String? mitraType,

  }) {
    return AuthState(
      fcmToken: fcmToken ?? this.fcmToken,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      profilePicture: profilePicture ?? this.profilePicture,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      mitraType: mitraType ?? this.mitraType,
    );
  }

  @override
  List<Object?> get props => [
        fcmToken,
        fullName,
        username,
        password,
        phoneNumber,
        passwordConfirmation,
        profilePicture,
        isPasswordVisible,
        rememberMe,
        mitraType,
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


// class ForgotPasswordLoaded extends AuthState {
//   final String message;

//   const ForgotPasswordLoaded({required this.message});

//   @override
//   List<Object?> get props => [message];
// }



// class EmailSentSuccess extends AuthState {}

