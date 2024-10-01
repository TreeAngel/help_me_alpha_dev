import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable{
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent{
  final String phoneNumber;

  const ForgotPasswordSubmitted(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];

}