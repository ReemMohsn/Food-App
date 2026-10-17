import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;

  factory UserProfileModel.fromUser(User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final fullName = (metadata['full_name'] ?? metadata['name'] ?? '').toString().trim();
    final avatarUrl = metadata['avatar_url'] as String?;

    return UserProfileModel(
      id: user.id,
      email: user.email ?? '',
      fullName: fullName.isNotEmpty ? fullName : 'Food Lover',
      avatarUrl: avatarUrl,
    );
  }
}
