import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable{
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  const ForgotPasswordError(this.error);

  @override
  List<Object> get props => [error];
}