class BankResponseModel {
  final String bankCode;
  final String bankName;
  final String accountNumber;
  final String accountName;
  BankResponseModel({
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  factory BankResponseModel.fromMap(Map<String, dynamic> map) {
    return BankResponseModel(
      bankCode: map['bankcode'] ?? '',
      bankName: map['bankname'] ?? '',
      accountNumber: map['accountnumber'] ?? '',
      accountName: map['accountname'] ?? '',
    );
  }
}
