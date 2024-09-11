import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String username;
  final String password;
  final bool isPasswordVisible;
  final bool isRememberMe;

  const SignInState({
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isRememberMe = false,
  });

  SignInState copyWith({
    String? username,
    String? password,
    bool? isPasswordVisible,
    bool? isRememberMe,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isRememberMe: isRememberMe ?? this.isRememberMe,
    );
  }

  @override
  List<Object> get props => [username, password, isPasswordVisible, isRememberMe];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInLoaded extends SignInState {
  final String message;
  final String token;

  const SignInLoaded({required this.message, required this.token});

  @override
  List<Object> get props => [message, token];
}

final class SignInError extends SignInState {
  final String errorMessage;

  const SignInError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
