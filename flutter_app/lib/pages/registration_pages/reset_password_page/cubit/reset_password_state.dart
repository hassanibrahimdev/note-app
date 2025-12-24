import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordMessage extends ResetPasswordState {
  final String message;

  ResetPasswordMessage({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
