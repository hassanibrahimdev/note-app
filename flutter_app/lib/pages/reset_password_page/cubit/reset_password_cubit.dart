import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/models/reset_password_model.dart';
import 'package:note_app/pages/reset_password_page/cubit/reset_password_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword(String password, String confirmPassword) async {
    if (password.trim().isEmpty || confirmPassword.trim().isEmpty) {
      emit(ResetPasswordMessage(message: "all fields must be filled!!"));
      return;
    }
    if (password.trim().length < 8) {
      emit(
        ResetPasswordMessage(
          message: "password must be at least 8 characters!!",
        ),
      );
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      emit(ResetPasswordMessage(message: "passwords must be the same!!"));
      return;
    }
    emit(ResetPasswordLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token == null) {
      emit(ResetPasswordMessage(message: "something went wrong"));
      return;
    }
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env["conn"] ?? "",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    try {
      ResetPasswordModel resetPasswordModel = ResetPasswordModel(
        password: password.trim(),
        confirmPassword: confirmPassword.trim(),
      );
      final response = await dio.post(
        "/User/resetpassword",
        data: resetPasswordModel.toJson(),
      );
      if (response.statusCode == 200) {
        emit(ResetPasswordSuccess());
        return;
      }
      emit(ResetPasswordMessage(message: "something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(ResetPasswordMessage(message: e.response!.data));
      } else {
        emit(ResetPasswordMessage(message: "Network Error"));
      }
    }
  }
}
