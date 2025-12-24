import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/pages/main_cubit/note_cubit.dart';
import 'package:note_app/pages/main_cubit/note_state.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late final NoteCubit _noteCubit = context.read<NoteCubit>();
  late final List<Note> _notes = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      buildWhen: (previous, current) => current is NoteSuccess,
      builder: (BuildContext context, state) {
        if (state is NoteSuccess) {
          _notes.clear();
          _notes.addAll(state.notes);
          return ListView.separated(
            itemBuilder: (context, index) {
              final dateTime = DateTime.fromMillisecondsSinceEpoch(
                state.notes[index].createdAt,
              );
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onLongPress: () {
                          _noteCubit.addOrRemoveNotesToUpdate(
                            state.notes[index].id,
                          );
                        },
                        onTap: () {
                          if (_noteCubit.notesToUpdate.isNotEmpty) {
                            _noteCubit.addOrRemoveNotesToUpdate(
                              state.notes[index].id,
                            );
                            return;
                          }
                        },
                        child: Row(
                          children: [
                            BlocBuilder<NoteCubit, NoteState>(
                              buildWhen: (previous, current) =>
                                  current is SelectNote,
                              builder: (BuildContext context, NoteState state) {
                                if (state is SelectNote) {
                                  if (state.ids.isEmpty) {
                                    return SizedBox();
                                  }
                                  return Row(
                                    children: [
                                      Icon(
                                        (state.ids.contains(_notes[index].id))
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.notes[index].title.substring(
                                      0,
                                      (state.notes[index].title.length < 15)
                                          ? state.notes[index].title.length
                                          : 15,
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    state.notes[index].content.substring(
                                      0,
                                      (state.notes[index].content.length < 10)
                                          ? state.notes[index].content.length
                                          : 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
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
                    ),

                    IconButton(
                      onPressed: () {
                        _noteCubit.addOrRemoveFavorite(state.notes[index]);
                      },
                      icon: Icon(
                        (state.notes[index].isFavorite)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(color: Colors.grey);
            },
            itemCount: state.notes.length,
          );
        }

        return Center(child: Text("Something went wrong"));
      },
    );
  }
}
