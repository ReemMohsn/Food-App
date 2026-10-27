import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final String _supabaseUrl = 'https://ulpnzejilxlvjyizlqoy.supabase.co';
  static final String _supabaseKey =
      'sb_publishable_FUm4zsx7DquSkhsVCurctA_x38VjIJx';

  /// The custom URL scheme registered in AndroidManifest.xml & Info.plist.
  /// Supabase will append this as the redirect after auth actions
  /// (password reset, OAuth sign-in, etc.) so the OS opens our app.
  static const String redirectUrl = 'com.example.foodapp://login-callback';

  static Future<void> initil() async {
    await Supabase.initialize(url: _supabaseUrl, publishableKey: _supabaseKey);
  }
}
