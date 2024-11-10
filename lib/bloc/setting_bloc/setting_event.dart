import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToProfileEvent extends SettingEvent {}

class SelectNotificationOptionEvent extends SettingEvent {
  final int selectedOption;

  const SelectNotificationOptionEvent(this.selectedOption);

  @override
  List<Object?> get props => [selectedOption];
}

class ExitAppEvent extends SettingEvent {}
