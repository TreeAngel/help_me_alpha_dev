part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthIsIdle extends AuthEvent {}

class ResetAuthState extends AuthEvent {}

class FullNameChanged extends AuthEvent {
  final String fullName;

  const FullNameChanged(this.fullName);

  @override
  List<Object> get props => [fullName];
}

class UsernameChanged extends AuthEvent {
  final String username;

  const UsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class PhoneNumberChanged extends AuthEvent {
  final String phoneNumber;

  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class PasswordChanged extends AuthEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class TogglePasswordVisibility extends AuthEvent {}

class ToggleRememberMe extends AuthEvent {}

class SignInSubmitted extends AuthEvent {}

class SignUpUserSubmitted extends AuthEvent {}

class SignUpMitraSubmitted extends AuthEvent {
  final CheckBankAccountState bankAccountState;

  const SignUpMitraSubmitted({required this.bankAccountState});

  @override
  List<Object> get props => [bankAccountState];
}

class SignOutSubmitted extends AuthEvent {}

class ForgetPasswordSubmitted extends AuthEvent {}

class MitraNameChanged extends AuthEvent {
  final String mitraName;

  const MitraNameChanged({required this.mitraName});

  @override
  List<Object> get props => [mitraName];
}

class CategoryIdChanged extends AuthEvent {
  final int categoryId;

  const CategoryIdChanged({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class AccountNumberChanged extends AuthEvent {
  final String accountNumber;

  const AccountNumberChanged({required this.accountNumber});

  @override
  List<Object> get props => [accountNumber];
}

class HelpersIdChanged extends AuthEvent {
  final List<int> helpersId;

  const HelpersIdChanged({required this.helpersId});

  @override
  List<Object> get props => [helpersId];
}
