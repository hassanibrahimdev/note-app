import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/pages/login_page/cubit/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['conn'] ?? "",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(LoginMessage(message: "all fields must be filled!!"));
      return;
    }
    if (!email.trim().contains("@")) {
      emit(LoginMessage(message: "Invalid email!!"));
      return;
    }
    emit(LoginLoading());
    try {
      final response = await _dio.post(
        "/User/login",
        data: {"email": email.trim(), "password": password.trim()},
      );
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["token"]);
        await prefs.setString("id", response.data["userId"]);
        await prefs.setString("email", response.data["user"]["email"]);
        await prefs.setString("name", response.data["user"]["name"]);
        emit(LoginSuccess());
        return;
      }
      emit(LoginMessage(message: "something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        emit(LoginMessage(message: e.response!.data));
      } else {
        emit(LoginMessage(message: "Network Error"));
      }
    }
  }
}
