import 'package:flutter/material.dart';
import 'package:food_app/core/routing/app_router.dart';
import 'package:food_app/core/routing/navigator_key.dart';
import 'package:food_app/core/themes/app_theme.dart';

class FoodApp extends StatelessWidget {
  const FoodApp({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigatorKey.navigatorKey,

      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
