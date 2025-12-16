import 'package:equatable/equatable.dart';

abstract class DrawerState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerLogOuted extends DrawerState {}


class DrawerSuccess extends DrawerState {
  final String id;
  final String name;
  final String email;

  DrawerSuccess({required this.id, required this.name, required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, email];
}
