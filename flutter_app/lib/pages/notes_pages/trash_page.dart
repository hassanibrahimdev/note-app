import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/pages/notes_pages/cubit/note_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/note_state.dart';
import 'package:note_app/pages/notes_pages/note_trash_page.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  late final NoteCubit _noteCubit = context.read<NoteCubit>();

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
        title: Text("Trash"),
        actions: [
          BlocBuilder<NoteCubit, NoteState>(
            buildWhen: (previous, current) => current is SelectNote,
            builder: (BuildContext context, NoteState state) {
              if (state is SelectNote) {
                if (state.ids.isNotEmpty) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _noteCubit.deleteNoteForever();
                        },
                        icon: Icon(Icons.delete_forever_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          _noteCubit.removeFromTrash();
                        },
                        icon: Icon(Icons.restore_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          _noteCubit.cancel();
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  );
                }
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
                .where((note) => (note.isDeleted))
                .toList();
            return notes.isEmpty
                ? Center(child: Text("No notes"))
                : NoteTrashPage(notes: notes);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
