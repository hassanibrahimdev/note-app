class ForgetPasswordModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String verifyCode;

  ForgetPasswordModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.verifyCode,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword,
    "verifyCode": verifyCode,
  };
}
