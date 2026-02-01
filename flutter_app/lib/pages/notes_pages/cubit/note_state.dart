import 'package:equatable/equatable.dart';
import 'package:note_app/database/note.dart';

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteSuccess extends NoteState {
  final List<Note> notes;

  NoteSuccess(this.notes);

  @override
  List<Object?> get props => [notes];
}

class LoadingState extends NoteState {}

class ErrorState extends NoteState {
  final String message;

  ErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SelectNote extends NoteState {
  final List<String> ids;
  final bool selectAll;

  SelectNote(this.ids, {required this.selectAll});

  @override
  List<Object?> get props => [ids, selectAll];
}
