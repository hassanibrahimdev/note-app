import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/pages/notes_pages/cubit/backup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(InitialState());

  Future<void> getBackupNotes() async {
    try {
      emit(LoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (token == null) {
        emit(ErrorState(message: "Login or sign up first"));
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
      final response = await dio.get("/Note/notes");
      if (response.statusCode == 200) {
        List<Note> notes = [];
        for (var note in response.data) {
          Note n = Note(
            id: note["noteId"],
            title: note["title"],
            content: note["content"],
            isFavorite: false,
            isArchived: false,
            isDeleted: false,
            createdAt: DateTime.parse(note["createdAt"]).millisecondsSinceEpoch,
            deletedAt: null,
          );
          notes.add(n);
        }
        emit(ViewNoteState(notes: notes));
      }
    } catch (e) {
      if (e is DioException) {
        if(e.response?.statusCode == 401){
          emit(ErrorState(message: "Login or sign up first"));
        }
      }
      emit(ErrorState(message: "Something went wrong"));
    }
  }
}
