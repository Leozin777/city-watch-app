import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../data/models/dtos/profile_edit_dto.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class EditFieldEvent extends ProfileEvent {
  final String fieldName;
  final String fieldValue;

  const EditFieldEvent({required this.fieldName, required this.fieldValue});

  @override
  List<Object?> get props => [fieldName, fieldValue];
}

class UpdateProfileImageEvent extends ProfileEvent {
  final File profileImage;

  const UpdateProfileImageEvent(this.profileImage);

  @override
  List<Object?> get props => [profileImage];
}

class UpdateProfileEvent extends ProfileEvent {
  final ProfileEditDto profileEditDto;

  const UpdateProfileEvent(this.profileEditDto);

  @override
  List<Object?> get props => [profileEditDto];
}
