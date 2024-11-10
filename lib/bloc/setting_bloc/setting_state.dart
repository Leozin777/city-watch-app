import 'package:equatable/equatable.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingState {}

class NotificationOptionSelectedState extends SettingState {
  final int selectedOption;

  const NotificationOptionSelectedState(this.selectedOption);

  @override
  List<Object?> get props => [selectedOption];
}

class SettingsExitAppState extends SettingState {}
