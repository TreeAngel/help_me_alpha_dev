import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/misc/check_e_wallet_model.dart';
import '../../services/api/api_helper.dart';

part 'check_bank_account_state.dart';

class CheckBankAccountCubit extends Cubit<CheckBankAccountState> {
  CheckBankAccountCubit() : super(CheckAccountInitial());
  String bankCode = '';
  String accountNumber = '';

  Future<void> checkBankAccount() async {
    if (bankCode.isEmpty) {
      emit(const CheckError(message: 'Pilih bank'));
    } else if (accountNumber.isEmpty) {
      emit(const CheckError(message: 'Isi dengan nomor rekening anda'));
    } else {
      emit(CheckLoading());
      final response =
          await ApiHelper.checkBankAccount(bankCode, accountNumber);
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.error ?? response.error?.message;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(AccountNumberNotExist(message: message.toString()));
      } else {
        emit(AccountNumberExist(bank: response));
      }
    }
  }
}
