import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/pages/home_page/cubit/drawer_cubit.dart';
import 'package:note_app/pages/home_page/drawer_page.dart';
import 'package:note_app/pages/main_cubit/note_cubit.dart';
import 'package:note_app/pages/main_cubit/note_state.dart';

import 'note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NoteCubit _noteCubit = context.read<NoteCubit>();

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
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete_outline),
                      ),
                      IconButton(
                        onPressed: () {
                          _noteCubit.archiveNotes();
                        },
                        icon: Icon(Icons.archive_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          _noteCubit.unarchiveNotes();
                        },
                        icon: Icon(Icons.unarchive_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.backup_outlined),
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
                return SizedBox();
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: const NotePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-note');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
