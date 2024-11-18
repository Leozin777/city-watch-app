import 'package:equatable/equatable.dart';

abstract class ProblemsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProblemsInitialState extends ProblemsState {}

class ModalOpenState extends ProblemsState {}
