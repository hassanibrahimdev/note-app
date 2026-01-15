import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/pages/registration_pages/sign_up_page/cubit/sign_up_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env["conn"] ?? "",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  SignUpCubit() : super(SignUpInitial());

  Future<void> sendVerificationCode(String email) async {
    if (email.trim().isEmpty) {
      emit(SignUpMessage(message: "email field must be filled!!"));
      return;
    }
    if (!email.trim().contains("@")) {
      emit(SignUpMessage(message: "Invalid email!!"));
      return;
    }
    emit(SignUpLoading());
    try {
      final response = await _dio.post(
        "/User/verifycode",
        data: {"email": email.trim()},
      );
      if (response.statusCode == 200) {
        emit(SignUpMessage(message: 'Code send successfully'));
        return;
      }
      emit(SignUpMessage(message: "something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(SignUpMessage(message: e.response!.data));
      } else {
        emit(SignUpMessage(message: "Network Error: ${e.message}"));
      }
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
    String verifyCode,
  ) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty ||
        verifyCode.trim().isEmpty) {
      emit(SignUpMessage(message: "all fields must be filled!!"));
      return;
    }
    if (password.trim().length < 8) {
      emit(SignUpMessage(message: "password must be at least 8 characters!!"));
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      emit(SignUpMessage(message: "passwords must be the same!!"));
      return;
    }
    emit(SignUpLoading());
    try {
      final response = await _dio.post(
        "/User/signup",
        data: {
          "name": name.trim(),
          "email": email.trim(),
          "password": password.trim(),
          "confirmPassword": confirmPassword.trim(),
          "verifyCode": verifyCode.trim(),
        },
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["token"]);
        await prefs.setString("id", response.data["userId"]);
        await prefs.setString("email", response.data["user"]["email"]);
        await prefs.setString("name", response.data["user"]["name"]);
        emit(SignUpSuccess());
        return;
      }
      emit(SignUpMessage(message: "something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(SignUpMessage(message: e.response!.data));
      } else {
        // Network error
        emit(SignUpMessage(message: "Network Error"));
      }
    }
  }
}
