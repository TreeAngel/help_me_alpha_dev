part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthIdle extends AuthState {}

final class PasswordToggled extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
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
final class SignUpUserLoaded extends AuthState {
  final String message;
  final String token;

  const SignUpUserLoaded({required this.message, required this.token});

  @override
  List<Object> get props => [message, token];
}

final class SignUpMitraLoaded extends AuthState {
  final String message;

  const SignUpMitraLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}

// Sign Out states
final class SignOutLoaded extends AuthState {
  final String message;

  const SignOutLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

final class ForgetPasswordLoaded extends AuthState {
  final String message;

  const ForgetPasswordLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

final class ForgetPasswordError extends AuthState {
  final String message;

  const ForgetPasswordError({required this.message});

  @override
  List<Object> get props => [message];
}

final class HelperIdChanged extends AuthState {}

final class MitraLocationChanged extends AuthState {}

final class SignUpMitraError extends AuthState {
  final String message;

  const SignUpMitraError({required this.message});

  @override
  List<Object?> get props => [message];
}
