part of 'check_bank_account_cubit.dart';

sealed class CheckBankAccountState extends Equatable {
  const CheckBankAccountState();

  @override
  List<Object?> get props => [];
}

final class CheckAccountInitial extends CheckBankAccountState {}

final class CheckLoading extends CheckBankAccountState {}

final class CheckAccountNumber extends CheckBankAccountState {}

final class CheckError extends CheckBankAccountState {
  final String message;

  const CheckError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AccountNumberExist extends CheckBankAccountState {
  final BankResponseModel bank;

  const AccountNumberExist({required this.bank});

  @override
  List<Object?> get props => [bank];
}

final class AccountNumberNotExist extends CheckBankAccountState {
  final String message;

  const AccountNumberNotExist({required this.message});

  @override
  List<Object?> get props => [message];
}
