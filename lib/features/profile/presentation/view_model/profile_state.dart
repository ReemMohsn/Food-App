import 'package:food_app/features/profile/data/models/user_profile_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  const ProfileSuccess({
    required this.user,
    this.isDarkMode = false,
  });

  final UserProfileModel user;
  final bool isDarkMode;

  ProfileSuccess copyWith({
    UserProfileModel? user,
    bool? isDarkMode,
  }) {
    return ProfileSuccess(
      user: user ?? this.user,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class ProfileFailure extends ProfileState {
  const ProfileFailure({required this.errorMessage});

  final String errorMessage;
}

class ProfileSignOutLoading extends ProfileState {
  const ProfileSignOutLoading();
}

class ProfileSignOutSuccess extends ProfileState {
  const ProfileSignOutSuccess();
}
