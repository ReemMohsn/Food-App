import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/dependency_injection/injection_container.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:food_app/features/auth/presentation/views/forgot_password_view.dart';
import 'package:food_app/features/auth/presentation/views/login_view.dart';
import 'package:food_app/features/auth/presentation/views/reset_password_view.dart';
import 'package:food_app/features/auth/presentation/views/sign_up_view.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:food_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:food_app/features/home/presentation/view_model/category_meals_cubit.dart';
import 'package:food_app/features/home/presentation/view_model/meal_details_cubit.dart';
import 'package:food_app/features/home/presentation/views/category_meals_view.dart';
import 'package:food_app/features/home/presentation/views/meal_details_view.dart';
import 'package:food_app/features/main_home/presentation/view_model/main_home_cubit.dart';
import 'package:food_app/features/main_home/presentation/views/main_home_view.dart';
import 'package:food_app/features/profile/presentation/view_model/profile_cubit.dart';

import 'routes.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return _authRoute((_) => const LoginView());
      case Routes.signUp:
        return _authRoute((_) => const SignUpView());
      case Routes.forgotPassword:
        return _authRoute((_) => const ForgotPasswordView());
      case Routes.resetPassword:
        // Opened via deep-link after user clicks reset email
        return _authRoute((_) => const ResetPasswordView());
      case Routes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => MainHomeCubit()),
              BlocProvider(create: (_) => sl<HomeCubit>()),
              BlocProvider.value(value: sl<FavoritesCubit>()),
              BlocProvider(create: (_) => sl<ProfileCubit>()),
            ],
            child: const MainHomeView(),
          ),
        );
      case Routes.categoryMeals:
        final arguments = settings.arguments;
        final categoryName = arguments is String
            ? arguments
            : (arguments is Map ? arguments['name'] as String? : null) ?? '';
        final categoryDescription = arguments is Map
            ? arguments['description'] as String?
            : null;
        return _categoryMealsRoute(
          settings: settings,
          categoryName: categoryName,
          categoryDescription: categoryDescription,
        );
      case Routes.mealDetails:
        final mealId = settings.arguments as String? ?? '';
        return _mealDetailsRoute(
          settings: settings,
          mealId: mealId,
        );
      default:
        return _notFound(settings);
    }
  }

  /// Wraps a page with the AuthCubit provider.
  Route<dynamic> _authRoute(WidgetBuilder builder) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: Builder(builder: builder),
      ),
    );
  }

  Route<dynamic> _categoryMealsRoute({
    required RouteSettings settings,
    required String categoryName,
    required String? categoryDescription,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<FavoritesCubit>()),
          BlocProvider(
            create: (_) => sl<CategoryMealsCubit>()
              ..getMealsByCategory(categoryName),
          ),
        ],
        child: CategoryMealsView(
          categoryName: categoryName,
          categoryDescription: categoryDescription,
        ),
      ),
    );
  }

  Route<dynamic> _mealDetailsRoute({
    required RouteSettings settings,
    required String mealId,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<FavoritesCubit>()),
          BlocProvider(
            create: (_) => sl<MealDetailsCubit>()..getMealDetails(mealId),
          ),
        ],
        child: const MealDetailsView(),
      ),
    );
  }

  Route<dynamic> _notFound(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        body: Center(child: Text('Page not found: ${settings.name}')),
      ),
    );
  }
}
