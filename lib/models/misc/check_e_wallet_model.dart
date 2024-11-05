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
      bankCode: map['bankCode'] ?? '',
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      accountName: map['accountName'] ?? '',
    );
  }
}
