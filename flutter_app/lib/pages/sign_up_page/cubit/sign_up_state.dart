import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpMessage extends SignUpState {
  final String message;

  SignUpMessage({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
