class SignUpModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String verifyCode;

  SignUpModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.verifyCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "verifyCode": verifyCode,
    };
  }
}