import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/services/errors/dio_error_mapper.dart';
import 'package:food_app/core/services/errors/failure.dart';
import 'package:food_app/core/services/errors/supabase_error_mapper.dart';

Future<Either<Failure, T>> requestHandler<T>(
  Future<T> Function() request,
) async {
  try {
    final data = await request();
    return Right<Failure, T>(data);
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrintStack(
        label: AppStrings.requestFailed(error.runtimeType),
        stackTrace: stackTrace,
      );
    }

    // Auto-detect error source and use the appropriate mapper.
    final failure = error is DioException
        ? DioErrorMapper.map(error)
        : SupabaseErrorMapper.map(error);

    return Left<Failure, T>(failure);
  }
}
