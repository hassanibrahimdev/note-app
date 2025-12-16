import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/models/forget_password_model.dart';
import 'package:note_app/models/verify_email_model.dart';
import 'package:note_app/pages/forget_password_page/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env["conn"] ?? "",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> sendCode(String email) async {
    if (email.trim().isEmpty) {
      emit(ForgetPasswordMessage(message: "email field must be filled!!"));
      return;
    }
    if (!email.trim().contains("@")) {
      emit(ForgetPasswordMessage(message: "Invalid email!!"));
    }
    emit(ForgetPasswordLoading());
    try {
      final VerifyEmailModel verifyEmailModel = VerifyEmailModel(
        email: email.trim(),
      );
      final response = await dio.post(
        "/User/verifycode",
        data: verifyEmailModel.toJson(),
      );
      if (response.statusCode == 200) {
        emit(ForgetPasswordMessage(message: 'Code send successfully'));
        return;
      }
      emit(ForgetPasswordMessage(message: "something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(ForgetPasswordMessage(message: e.response!.data));
      } else {
        emit(ForgetPasswordMessage(message: "Network Error"));
      }
    }
  }

  Future<void> resetPassword(
    String email,
    String password,
    String confirmPassword,
    String verifyCode,
  ) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty ||
        verifyCode.trim().isEmpty) {
      emit(ForgetPasswordMessage(message: "all fields must be filled!!"));
      return;
    }
    if (!email.trim().contains("@")) {
      emit(ForgetPasswordMessage(message: "Invalid email!!"));
      return;
    }
    if (password.trim().length < 8) {
      emit(
        ForgetPasswordMessage(
          message: "password must be at least 8 characters!!",
        ),
      );
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      emit(ForgetPasswordMessage(message: "passwords must be the same!!"));
      return;
    }
    emit(ForgetPasswordLoading());
    try {
      final ForgetPasswordModel forgetPasswordModel = ForgetPasswordModel(
        email: email.trim(),
        password: password.trim(),
        confirmPassword: confirmPassword.trim(),
        verifyCode: verifyCode.trim(),
      );
      final response = await dio.post(
        "/User/forgetpassword",
        data: forgetPasswordModel.toJson(),
      );
      if (response.statusCode == 200) {
        emit(ForgetPasswordSuccess());
        return;
      }
      emit(ForgetPasswordMessage(message: "something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(ForgetPasswordMessage(message: e.response!.data));
      } else {
        emit(ForgetPasswordMessage(message: "Network Error"));
      }
    }
  }
}
