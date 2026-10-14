abstract class AuthState {}

class AuthInitial extends AuthState {}

// ── Login ─────────────────────────────────────────────────────
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  LoginSuccess({required this.message});
  final String message;
}

class LoginFailure extends AuthState {
  LoginFailure({required this.errorMessage});
  final String errorMessage;
}

// ── Sign Up ───────────────────────────────────────────────────
class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  SignUpSuccess({required this.message});
  final String message;
}

class SignUpFailure extends AuthState {
  SignUpFailure({required this.errorMessage});
  final String errorMessage;
}

// ── Sign Out ──────────────────────────────────────────────────
class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {
  SignOutSuccess({required this.message});
  final String message;
}

class SignOutFailure extends AuthState {
  SignOutFailure({required this.errorMessage});
  final String errorMessage;
}

// ── Forgot Password ───────────────────────────────────────────
class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  ForgotPasswordSuccess({required this.message});
  final String message;
}

class ForgotPasswordFailure extends AuthState {
  ForgotPasswordFailure({required this.errorMessage});
  final String errorMessage;
}

// ── Update Password (after reset link) ───────────────────────
class UpdatePasswordLoading extends AuthState {}

class UpdatePasswordSuccess extends AuthState {
  UpdatePasswordSuccess({required this.message});
  final String message;
}

class UpdatePasswordFailure extends AuthState {
  UpdatePasswordFailure({required this.errorMessage});
  final String errorMessage;
}

// ── Google Sign-In ────────────────────────────────────────────
class GoogleSignInLoading extends AuthState {}

class GoogleSignInSuccess extends AuthState {}

class GoogleSignInFailure extends AuthState {
  GoogleSignInFailure({required this.errorMessage});
  final String errorMessage;
}
