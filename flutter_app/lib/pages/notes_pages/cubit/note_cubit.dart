import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/pages/main_cubit/note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());
  final NoteDatabase _noteDatabase = NoteDatabase();
  List<Note> notes = [];
  List<String> notesToUpdate = [];

  Future<void> getNotes() async {
    try {
      notes = await _noteDatabase.getAllNotes();
      emit(NoteSuccess(notes));
    } catch (e) {
      emit(ErrorState(message: "Something went wrong"));
    }
  }

  Future<void> addOrRemoveFavorite(Note note) async {
    try {
      if (!note.isFavorite) {
        await NoteDatabase().addToFavorites(note.id, 1);
      } else {
        await NoteDatabase().addToFavorites(note.id, 0);
      }
      getNotes();
    } catch (e) {
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
      for (String id in notesToUpdate) {
        await NoteDatabase().archiveNotes(id);
      }
      getNotes();
      cancel();
    } catch (e) {
      emit(ErrorState(message: "Something went wrong when adding to archive"));
    }
  }

  Future<void> unarchiveNotes() async {
    if (notesToUpdate.isEmpty) {
      return;
    }
    try {
      for (String id in notesToUpdate) {
        await NoteDatabase().unarchiveNotes(id);
      }
      getNotes();
    } catch (e) {
      emit(
        ErrorState(message: "Something went wrong when removing from archive"),
      );
    }
  }

  void addOrRemoveNotesToUpdate(String id) {
    if (notesToUpdate.contains(id)) {
      notesToUpdate.remove(id);
    } else {
      notesToUpdate.add(id);
    }
    emit(SelectNote(List<String>.from(notesToUpdate)));
  }

  void cancel() {
    notesToUpdate.clear();
    emit(SelectNote([]));
  }
}
