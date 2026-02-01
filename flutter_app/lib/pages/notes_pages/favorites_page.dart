import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/pages/notes_pages/cubit/note_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/note_state.dart';
import 'package:note_app/pages/notes_pages/note_page.dart';
import 'package:note_app/widgets/widgets.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final NoteCubit _noteCubit = context.read<NoteCubit>();
  late final Widgets _widget = Widgets();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noteCubit.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        actions: [
          BlocBuilder<NoteCubit, NoteState>(
            buildWhen: (previous, current) {
              return current is SelectNote;
            },
            builder: (BuildContext context, NoteState state) {
              if (state is SelectNote) {
                if (state.ids.isNotEmpty) {
                  return _widget.actionInAppBar(
                    _noteCubit.cancel,
                    _noteCubit.moveToTrash,
                    _noteCubit.archiveNotes,
                    _noteCubit.syncData,
                    Icon(Icons.archive_outlined),
                  );
                }
                return SizedBox();
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        buildWhen: (previous, current) => current is NoteSuccess,
        builder: (BuildContext context, NoteState state) {
          if (state is NoteSuccess) {
            List<Note> notes = state.notes
                .where((note) => (note.isFavorite && !note.isDeleted))
                .toList();
            return notes.isEmpty
                ? Center(child: Text("No notes"))
                : NotePage(notes: notes);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
