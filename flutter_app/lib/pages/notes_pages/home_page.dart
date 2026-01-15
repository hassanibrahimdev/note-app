import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/pages/notes_pages/cubit/drawer_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/note_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/note_state.dart';
import 'package:note_app/pages/notes_pages/drawer_page.dart';
import 'package:note_app/pages/notes_pages/note_page.dart';
import 'package:note_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final NoteCubit _noteCubit = context.read<NoteCubit>();
  late final Widgets _widget = Widgets();

  @override
  void initState() {
    super.initState();
    _noteCubit.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BlocProvider<DrawerCubit>(
        create: (BuildContext context) => DrawerCubit(),
        child: DrawerPage(),
      ),
      appBar: AppBar(
        title: Text("Notes"),
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
                .where((note) => (!note.isDeleted && !note.isArchived))
                .toList();
            return notes.isEmpty
                ? Center(child: Text("No notes"))
                : NotePage(notes: notes);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-note');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
