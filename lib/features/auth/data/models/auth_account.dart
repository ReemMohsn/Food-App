import 'package:supabase_flutter/supabase_flutter.dart';

class AuthAccount {
  final String id;
  final String email;
  final String fullName;

  AuthAccount({required this.id, required this.email, required this.fullName});

  static AuthAccount? fromUser(User? user) {
    if (user == null) return null;

    final metadata = user.userMetadata ?? const <String, dynamic>{};
    return AuthAccount(
      id: user.id,
      email: user.email ?? '',
      fullName: (metadata['full_name'] ?? metadata['name'] ?? '').toString(),
    );
  }
}
