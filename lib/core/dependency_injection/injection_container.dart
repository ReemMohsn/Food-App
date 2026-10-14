import 'package:dio/dio.dart';
import 'package:food_app/core/services/api_service.dart';
import 'package:food_app/core/services/shared_preferences_service.dart';
import 'package:food_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_app/features/auth/data/repositories/auth_repository.dart';
import 'package:food_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:food_app/features/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:food_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:food_app/features/home/data/repositories/home_repository.dart';
import 'package:food_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:food_app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_app/features/profile/data/repositories/profile_repository.dart';
import 'package:food_app/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External & Core Services
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(),
  );
  sl.registerLazySingleton<ApiService>(
    () => ApiService(sl<SharedPreferencesService>()),
  );

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<AuthRemoteDataSource>()),
  );
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl<AuthRepository>()),
  );

  // Home Feature
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(sl<ApiService>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepository(sl<HomeRemoteDataSource>()),
  );
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(sl<HomeRepository>()),
  );

  // Favorites Feature
  sl.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(sl<SharedPreferencesService>())..loadFavorites(),
  );

  // Profile Feature
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(
      sl<ProfileRemoteDataSource>(),
      sl<AuthRepository>(),
    ),
  );
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(sl<ProfileRepository>()),
  );
}

