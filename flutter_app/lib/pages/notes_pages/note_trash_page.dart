import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/pages/notes_pages/cubit/note_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/note_state.dart';

class NoteTrashPage extends StatefulWidget {
  const NoteTrashPage({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<NoteTrashPage> createState() => _NoteTrashPageState();
}

class _NoteTrashPageState extends State<NoteTrashPage> {
  late final NoteCubit _noteCubit = context.read<NoteCubit>();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          widget.notes[index].deletedAt ?? 0,
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
                      widget.notes[index].id,
                      widget.notes,
                    );
                  },
                  onTap: () {
                    if (_noteCubit.notesToUpdate.isNotEmpty) {
                      _noteCubit.addOrRemoveNotesToUpdate(
                        widget.notes[index].id,
                        widget.notes,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      BlocBuilder<NoteCubit, NoteState>(
                        buildWhen: (previous, current) => current is SelectNote,
                        builder: (BuildContext context, NoteState state) {
                          if (state is SelectNote) {
                            if (state.ids.isEmpty) {
                              return SizedBox();
                            }
                            return Row(
                              children: [
                                Icon(
                                  (state.ids.contains(widget.notes[index].id))
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
                              widget.notes[index].title.substring(
                                0,
                                (widget.notes[index].title.length < 15)
                                    ? widget.notes[index].title.length
                                    : 15,
                              ),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.notes[index].content.substring(
                                0,
                                (widget.notes[index].content.length < 10)
                                    ? widget.notes[index].content.length
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
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.grey);
      },
      itemCount: widget.notes.length,
    );
  }
}
