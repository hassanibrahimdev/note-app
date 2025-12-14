import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/pages/home_page/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeInitial());

}