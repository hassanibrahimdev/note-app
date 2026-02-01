import 'package:equatable/equatable.dart';
import 'package:note_app/database/note.dart';

abstract class BackupState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialState extends BackupState{}
class LoadingState extends BackupState{}
class ViewNoteState extends BackupState{
  final List<Note> notes;

  ViewNoteState({required this.notes});
  @override
  // TODO: implement props
  List<Object?> get props => [notes];
}
class ErrorState extends BackupState{
  final String message;

  ErrorState({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}