import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/pages/notes_pages/cubit/note_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());
  final NoteDatabase _noteDatabase = NoteDatabase();
  List<Note> notes = [];
  List<String> notesToUpdate = [];
  bool selectAll = false;

  void addOrRemoveNotesToUpdate(String id, List<Note> n) {
    if (notesToUpdate.contains(id)) {
      notesToUpdate.remove(id);
      selectAll = false;
    } else {
      notesToUpdate.add(id);
      if (notesToUpdate.length == n.length) {
        selectAll = true;
      }
    }
    emit(SelectNote(List<String>.from(notesToUpdate), selectAll: selectAll));
  }

  void selectAllNotes() {
    notesToUpdate.clear();
    for (Note note in notes) {
      notesToUpdate.add(note.id);
    }
    emit(SelectNote(List<String>.from(notesToUpdate), selectAll: true));
  }

  void cancel() {
    notesToUpdate.clear();
    emit(SelectNote([], selectAll: false));
  }

  Future<void> getNotes() async {
    try {
      notes = await _noteDatabase.getAllNotes();
      emit(NoteSuccess(List<Note>.from(notes)));
    } catch (e) {
      emit(ErrorState(message: "Something went wrong"));
    }
  }

  Future<void> addOrRemoveFavorite(String id) async {
    try {
      final index = notes.indexWhere((n) => n.id == id);
      if (index == -1) return;

      notes[index] = notes[index].copyWith(
        isFavorite: !notes[index].isFavorite,
      );

      _noteDatabase.addToFavorites(id, notes[index].isFavorite ? 1 : 0);

      emit(NoteSuccess(List<Note>.from(notes)));
    } catch (e) {
      cancel();
      emit(
        ErrorState(message: "Something went wrong when adding to favorites"),
      );
    }
  }

  Future<void> archiveNotes() async {
    if (notesToUpdate.isEmpty) {
      return;
    }
    try {
      List<int> indexes = [];
      for (String id in notesToUpdate) {
        indexes.add(notes.indexWhere((note) => note.id == id));
      }
      for (int index in indexes) {
        notes[index] = notes[index].copyWith(isArchived: true);
      }
      await _noteDatabase.archiveNotes(notesToUpdate, 1);
      cancel();
      emit(NoteSuccess(List<Note>.from(notes)));
    } catch (e) {
      cancel();
      emit(ErrorState(message: "Something went wrong when adding to archive"));
    }
  }

  Future<void> unarchiveNotes() async {
    if (notesToUpdate.isEmpty) {
      return;
    }
    try {
      List<int> indexes = [];
      for (String id in notesToUpdate) {
        indexes.add(notes.indexWhere((note) => note.id == id));
      }
      for (int index in indexes) {
        notes[index] = notes[index].copyWith(isArchived: false);
      }
      await _noteDatabase.archiveNotes(notesToUpdate, 0);
      cancel();
      emit(NoteSuccess(List<Note>.from(notes)));
    } catch (e) {
      cancel();
      emit(
        ErrorState(message: "Something went wrong when removing from archive"),
      );
    }
  }

  Future<void> moveToTrash() async {
    if (notesToUpdate.isEmpty) {
      return;
    }
    try {
      await _noteDatabase.moveToTrash(notesToUpdate);
      getNotes();
      cancel();
    } catch (e) {
      cancel();
      emit(ErrorState(message: "Something went wrong when moving to trash"));
    }
  }

  Future<void> removeFromTrash() async {
    if (notesToUpdate.isEmpty) {
      return;
    }
    try {
      await _noteDatabase.removeFromTrash(notesToUpdate);
      getNotes();
      cancel();
    } catch (e) {
      cancel();
      emit(ErrorState(message: "Something went wrong when moving to trash"));
    }
  }

  Future<void> deleteNoteForever() async {
    if (notesToUpdate.isEmpty) {
      return;
    }
    try {
      await _noteDatabase.deleteNotes(notesToUpdate);
      getNotes();
      cancel();
    } catch (e) {
      cancel();
      emit(ErrorState(message: "Something went wrong when deleting note"));
    }
  }



  Future<void> syncData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
      final updatedNotes = notes
          .where((note) => notesToUpdate.contains(note.id))
          .toList();
      if (updatedNotes.isEmpty) {
        return;
      }
      await dio.post(
        '/Note/notes',
        data: updatedNotes
            .map(
              (note) => {
                "noteId": note.id,
                "title": note.title,
                "content": note.content,
                "createdAt": note.createdAt,
              },
            )
            .toList(),
      );
      cancel();
    } catch (e) {
      cancel();
      emit(ErrorState(message: "Something went wrong when syncing data"));
    }
  }
}
