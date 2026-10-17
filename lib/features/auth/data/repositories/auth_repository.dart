import 'package:dartz/dartz.dart';
import 'package:food_app/core/services/errors/failure.dart';
import 'package:food_app/core/services/request_handler.dart';
import 'package:food_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_app/features/auth/data/models/auth_account.dart';

class AuthRepository {
  const AuthRepository(this._remote);
  final AuthRemoteDataSource _remote;

  Future<Either<Failure, AuthAccount>> signIn({
    required String email,
    required String password,
  }) => requestHandler(() => _remote.signIn(email: email, password: password));

  Future<Either<Failure, AuthAccount>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) => requestHandler(
    () => _remote.signUp(fullName: fullName, email: email, password: password),
  );

  Future<Either<Failure, void>> signOut() => requestHandler(_remote.signOut);

  Future<Either<Failure, void>> resetPassword({required String email}) =>
      requestHandler(() => _remote.resetPasswordForEmail(email));

  Future<Either<Failure, void>> updatePassword({
    required String newPassword,
  }) => requestHandler(() => _remote.updatePassword(newPassword));

  Future<Either<Failure, void>> signInWithGoogle() =>
      requestHandler(_remote.signInWithGoogle);
}
