import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/profile/data/repositories/profile_repository.dart';
import 'package:food_app/features/profile/presentation/view_model/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileInitial());

  final ProfileRepository _repository;

  Future<void> getProfile() async {
    emit(const ProfileLoading());
    final result = await _repository.getUserProfile();
    if (isClosed) return;

    result.fold(
      (failure) => emit(ProfileFailure(errorMessage: failure.message)),
      (user) => emit(ProfileSuccess(user: user)),
    );
  }

  void toggleDarkMode(bool value) {
    if (state is ProfileSuccess) {
      final current = state as ProfileSuccess;
      emit(current.copyWith(isDarkMode: value));
    }
  }

  Future<void> signOut() async {
    emit(const ProfileSignOutLoading());
    final result = await _repository.signOut();
    if (isClosed) return;

    result.fold(
      (failure) => emit(ProfileFailure(errorMessage: failure.message)),
      (_) => emit(const ProfileSignOutSuccess()),
    );
  }
}
