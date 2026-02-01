import 'package:bson/bson.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/pages/notes_pages/add_note_page/cubit/add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteInitial());

  Future<void> addNote(String title, String content) async {
    if (title.trim().isEmpty || content.trim().isEmpty) {
      emit(AddNoteMessage(message: "all fields must be filled!!"));
      return;
    }
    NoteDatabase noteDatabase = NoteDatabase();
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    try {
      await noteDatabase.insertNote(
        Note(
          id: ObjectId().oid,
          title: title.trim(),
          content: content,
          isFavorite: false,
          isArchived: false,
          isDeleted: false,
          createdAt: createdAt,
          deletedAt: null,
        ),
      );
      emit(AddNoteSuccess());
    } catch (e) {
      emit(AddNoteMessage(message: "Something went wrong"));
    }
  }
}
