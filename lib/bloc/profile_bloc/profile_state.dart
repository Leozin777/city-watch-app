import 'dart:io';
import 'package:city_watch/data/models/dtos/profile_edit_dto.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileImageUpdatedState extends ProfileState {
  final File profileImage;

  const ProfileImageUpdatedState(this.profileImage);

  @override
  List<Object?> get props => [profileImage];
}

class ProfileFieldUpdatedState extends ProfileState {
  final String fieldName;
  final String fieldValue;

  const ProfileFieldUpdatedState({required this.fieldName, required this.fieldValue});

  @override
  List<Object?> get props => [fieldName, fieldValue];
}

class ProfileUpdateLoadingState extends ProfileState {}

class ProfileUpdateSuccessState extends ProfileState {
  final String message;
  final ProfileEditDto updatedProfile;

  const ProfileUpdateSuccessState(this.message, this.updatedProfile);

  @override
  List<Object?> get props => [message, updatedProfile];
}


class ProfileUpdateFailureState extends ProfileState {
  final String error;

  const ProfileUpdateFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
