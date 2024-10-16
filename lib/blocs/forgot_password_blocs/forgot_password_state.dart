import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable{
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

enum ForgotPasswordErrorType {
  phoneNotVerified,
  serverError,
  unknown, //error tidak spesifik
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;
  final ForgotPasswordErrorType errorType;

  const ForgotPasswordError(this.error, this.errorType);

  @override
  List<Object> get props => [error, errorType];
}


class ForgotPasswordPhoneNotVerified extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}
