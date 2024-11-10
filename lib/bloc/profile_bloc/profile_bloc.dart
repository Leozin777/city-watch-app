import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_bloc/profile_event.dart';
import '../../bloc/profile_bloc/profile_state.dart';
import '../../data/models/interface/iprofile_service.dart';
import '../../main.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileService _profileService;

  ProfileBloc({required IProfileService profileService})
      : _profileService = profileService,
        super(ProfileInitialState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is EditFieldEvent) {
      yield ProfileFieldUpdatedState(
        fieldName: event.fieldName,
        fieldValue: event.fieldValue,
      );
    } else if (event is UpdateProfileImageEvent) {
      yield ProfileImageUpdatedState(event.profileImage);
    }

  }
}
