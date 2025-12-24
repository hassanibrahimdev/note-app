import 'package:equatable/equatable.dart';

abstract class ForgetPasswordState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordMessage extends ForgetPasswordState {
  final String message;

  ForgetPasswordMessage({required this.message});

  @override
  List<Object?> get props => [message];
}
