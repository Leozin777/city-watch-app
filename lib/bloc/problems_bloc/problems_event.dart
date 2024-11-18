import 'package:equatable/equatable.dart';

abstract class ProblemsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OpenModalEvent extends ProblemsEvent {}

class CloseModalEvent extends ProblemsEvent {}
