import 'package:equatable/equatable.dart';

abstract class AddNoteState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddNoteInitial extends AddNoteState {}

class AddNoteSuccess extends AddNoteState {}

class AddNoteLoading extends AddNoteState {}

class AddNoteMessage extends AddNoteState {
  final String message;

  AddNoteMessage({required this.message});

  @override
  List<Object?> get props => [message];
}
