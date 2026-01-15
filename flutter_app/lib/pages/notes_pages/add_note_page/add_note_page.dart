import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/notes_pages/add_note_page/cubit/add_note_cubit.dart';
import 'package:note_app/pages/notes_pages/add_note_page/cubit/add_note_state.dart';
import 'package:note_app/widgets/widgets.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final Widgets _widgets = Widgets();
  late final AddNoteCubit _cubit = context.read<AddNoteCubit>();
  late final DeviceInfo _deviceInfo = DeviceInfo(context);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late final double _height = _deviceInfo.height;
  late final double _width = _deviceInfo.width;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddNoteCubit, AddNoteState>(
      listener: (BuildContext context, AddNoteState state) {
        if (state is AddNoteSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Note"),
          actions: [
            BlocSelector<AddNoteCubit, AddNoteState, bool>(
              selector: (state) {
                if (state is AddNoteLoading) {
                  return true;
                }
                return false;
              },
              builder: (BuildContext context, state) {
                return MaterialButton(
                  onPressed: () {
                    _cubit.addNote(
                      _titleController.text,
                      _contentController.text,
                    );
                  },
                  color: Colors.green,
                  child: Text("Save"),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: _width * 0.8,
                  height: _height * 0.8,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Column(
                      children: [
                        _widgets.textField(
                          'Title',
                          'Enter Title',
                          Icon(Icons.title),
                          _titleController,
                        ),
                        SizedBox(height: _height * 0.02),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _contentController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              hint: Text("Type something....."),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _height * 0.02),
                        BlocBuilder<AddNoteCubit, AddNoteState>(
                          buildWhen: (previous, current) => current is AddNoteMessage,
                          builder: (BuildContext context, AddNoteState state) {
                            String message = "";
                            if (state is AddNoteMessage) {
                              message = state.message;
                            }
                            return Text(message);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
