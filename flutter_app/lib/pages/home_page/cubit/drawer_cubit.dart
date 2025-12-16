import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/pages/home_page/cubit/drawer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());

  Future<void> checkSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token == null) {
      return;
    }
    String id = prefs.getString("id") ?? "";
    String name = prefs.getString("name") ?? "";
    String email = prefs.getString("email") ?? "";
    emit(DrawerSuccess(id: id, name: name, email: email));
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(DrawerLogOuted());
  }

  Future<void> deleteAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token == null) {
      return;
    }
    Dio dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env["conn"] ?? "",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    final response = await dio.delete("/User/deleteuser");
    if(response.statusCode == 200){
      prefs.clear();
      emit(DrawerLogOuted());
    }
  }
}
