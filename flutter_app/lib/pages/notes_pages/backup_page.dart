import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/pages/notes_pages/cubit/backup_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/backup_state.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  late final BackupCubit _backupCubit = context.read<BackupCubit>();

  @override
  void initState() {
    super.initState();
    _backupCubit.getBackupNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Backup"), actions: []),
      body: BlocBuilder<BackupCubit, BackupState>(
        buildWhen: (previous, current) => current is ViewNoteState,
        builder: (BuildContext context, BackupState state) {
          if (state is ViewNoteState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final dateTime = DateTime.fromMillisecondsSinceEpoch(
                  state.notes[index].createdAt,
                );
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.notes[index].title.length < 15
                                    ? state.notes[index].title
                                    : "${state.notes[index].title.substring(0, 15)}...",
                              ),
                              Text(
                                state.notes[index].content.length < 15
                                    ? state.notes[index].content
                                    : "${state.notes[index].content.substring(0, 15)}..."
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Text(
                                "${dateTime.year}-${dateTime.month}-${dateTime.day}",
                              ),
                              Text(
                                "${dateTime.hour}:${dateTime.minute}:${dateTime.second}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: state.notes.length,
            );
          }
          return Center(child: Text("No notes"));
        },
      ),
    );
  }
}
