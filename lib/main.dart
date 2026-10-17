import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:food_app/core/dependency_injection/injection_container.dart';
import 'package:food_app/core/networking/supabase_service.dart';
import 'package:food_app/core/routing/app_router.dart';
import 'package:food_app/core/routing/navigator_key.dart';
import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/food_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await SupabaseService.initil();
  await initDependencies();

  // ── Listen to Supabase auth state changes ─────────────────
  // When the user clicks the password-reset link in their email,
  // Supabase opens our app via deep link and fires a
  // passwordRecovery event — we navigate to the reset screen.
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;
    final navigator = NavigatorKey.navigatorKey.currentState;
    if (navigator == null) return;

    switch (event) {
      case AuthChangeEvent.passwordRecovery:
        // Deep link opened → take user to "set new password" screen
        navigator.pushNamedAndRemoveUntil(
          Routes.resetPassword,
          (route) => false,
        );
      case AuthChangeEvent.signedIn:
        // Handles OAuth (Google) sign-in redirect coming back to the app
        final session = data.session;
        if (session != null) {
          navigator.pushNamedAndRemoveUntil(
            Routes.home,
            (route) => false,
          );
        }
      default:
        break;
    }
  });

  runApp(FoodApp(appRouter: AppRouter(), initialRoute: Routes.login));
  FlutterNativeSplash.remove();
}
