import 'package:food_app/features/profile/data/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<UserProfileModel> getUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('No logged in user found.');
    }
    return UserProfileModel.fromUser(user);
  }
}

