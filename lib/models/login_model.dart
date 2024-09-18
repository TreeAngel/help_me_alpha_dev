class LoginModel {
  final String username;
  final String password; // Change to base64 String

  LoginModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
