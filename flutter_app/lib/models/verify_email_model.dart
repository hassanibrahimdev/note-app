class VerifyEmailModel {
  final String email;

  VerifyEmailModel({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}
