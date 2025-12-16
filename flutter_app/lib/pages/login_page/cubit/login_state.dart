import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginMessage extends LoginState {
  final String message;

  LoginMessage({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
