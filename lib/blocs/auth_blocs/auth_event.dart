part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class FcmTokenChanged extends AuthEvent {
  final String fcmToken;

  const FcmTokenChanged(this.fcmToken);

  @override
  List<Object> get props => [fcmToken];
}

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

class ProfileImageChanged extends AuthEvent {
  final XFile image;

  const ProfileImageChanged(this.image);

  @override
  List<XFile> get props => [image];
}

class MitraTypeChanged extends AuthEvent {
  final String mitraType;

  const MitraTypeChanged({required this.mitraType});

  @override
  List<Object> get props => [mitraType];
}



// class ForgotPasswordSubmitted extends AuthEvent {
//   final String email;

//   const ForgotPasswordSubmitted({required this.email});

//   @override
//   List<Object> get props => [email];
// }

// class SendResetPasswordEmail extends AuthEvent {
//   final String email;

//   SendResetPasswordEmail(this.email);
// }

// class StartPasswordChangePolling extends AuthEvent {}


class TogglePasswordVisibility extends AuthEvent {}

class ToggleRememberMe extends AuthEvent {}

class SignInSubmitted extends AuthEvent {}

class SignUpSubmitted extends AuthEvent {}

class SignOutSubmitted extends AuthEvent {}

class ResetAuthState extends AuthEvent {}
