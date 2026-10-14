import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/features/auth/data/repositories/auth_repository.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthInitial());

  final AuthRepository _repository;

  // ── Sign In ────────────────────────────────────────────────
  Future<void> signIn({required String email, required String password}) async {
    emit(LoginLoading());
    final response =
        await _repository.signIn(email: email, password: password);
    response.fold(
      (failure) => emit(LoginFailure(errorMessage: failure.message)),
      (_) => emit(LoginSuccess(message: AppStrings.welcomeBack)),
    );
  }

  // ── Sign Up ────────────────────────────────────────────────
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());
    final response = await _repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    response.fold(
      (failure) => emit(SignUpFailure(errorMessage: failure.message)),
      (_) =>
          emit(SignUpSuccess(message: AppStrings.accountCreatedSuccessfully)),
    );
  }

  // ── Sign Out ───────────────────────────────────────────────
  Future<void> signOut() async {
    emit(SignOutLoading());
    final response = await _repository.signOut();
    response.fold(
      (failure) => emit(SignOutFailure(errorMessage: failure.message)),
      (_) =>
          emit(SignOutSuccess(message: AppStrings.loggedOutSuccessfully)),
    );
  }

  // ── Forgot Password ────────────────────────────────────────
  Future<void> resetPassword({required String email}) async {
    emit(ForgotPasswordLoading());
    final response = await _repository.resetPassword(email: email);
    response.fold(
      (failure) =>
          emit(ForgotPasswordFailure(errorMessage: failure.message)),
      (_) => emit(
        ForgotPasswordSuccess(message: AppStrings.passwordResetEmailSent),
      ),
    );
  }

  // ── Update Password (after clicking reset link) ────────────
  Future<void> updatePassword({required String newPassword}) async {
    emit(UpdatePasswordLoading());
    final response =
        await _repository.updatePassword(newPassword: newPassword);
    response.fold(
      (failure) =>
          emit(UpdatePasswordFailure(errorMessage: failure.message)),
      (_) => emit(
        UpdatePasswordSuccess(
            message: AppStrings.passwordUpdatedSuccessfully),
      ),
    );
  }

  // ── Google Sign-In ─────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    final response = await _repository.signInWithGoogle();
    response.fold(
      (failure) =>
          emit(GoogleSignInFailure(errorMessage: failure.message)),
      (_) => emit(GoogleSignInSuccess()),
    );
  }
}
