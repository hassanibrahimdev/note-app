import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/pages/home_page/cubit/drawer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());

  Future<void> checkSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token == null) {
      return ;
    }
    String id = prefs.getString("id") ?? "";
    String name = prefs.getString("name") ?? "";
    String email = prefs.getString("email") ?? "";
    emit(DrawerSuccess(id: id, name: name, email: email));
  }
}