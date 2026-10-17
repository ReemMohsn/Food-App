import 'package:dartz/dartz.dart';
import 'package:food_app/core/services/errors/failure.dart';
import 'package:food_app/core/services/request_handler.dart';
import 'package:food_app/features/auth/data/repositories/auth_repository.dart';
import 'package:food_app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_app/features/profile/data/models/user_profile_model.dart';

class ProfileRepository {
  const ProfileRepository(this._remote, this._authRepository);

  final ProfileRemoteDataSource _remote;
  final AuthRepository _authRepository;

  Future<Either<Failure, UserProfileModel>> getUserProfile() =>
      requestHandler(_remote.getUserProfile);

  Future<Either<Failure, void>> signOut() => _authRepository.signOut();
}

