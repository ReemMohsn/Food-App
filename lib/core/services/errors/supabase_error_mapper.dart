import 'dart:async';
import 'package:food_app/core/constants/app_strings.dart';
import 'package:food_app/core/services/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseErrorMapper {
  static const Map<String, String> _authMessages = {
    'invalid_credentials': AppStrings.theSignInDetailsAreIncorrect,
    'email_not_confirmed': AppStrings.pleaseConfirmYourEmailBeforeSigningIn,
    'phone_not_confirmed':
        AppStrings.pleaseConfirmYourPhoneNumberBeforeSigningIn,
    'email_exists': AppStrings.anAccountWithThisEmailAlreadyExists,
    'user_already_exists': AppStrings.anAccountWithTheseDetailsAlreadyExists,
    'weak_password': AppStrings.pleaseChooseAStrongerPassword,
    'same_password':
        AppStrings.pleaseChooseAPasswordDifferentFromYourCurrentOne,
    'otp_expired': AppStrings.theVerificationLinkOrCodeHasExpiredRequestANewOne,
    'session_not_found': AppStrings.pleaseSignInAgainToContinue,
    'session_expired': AppStrings.yourSessionHasExpiredPleaseSignInAgain,
    'refresh_token_not_found': AppStrings.pleaseSignInAgainToContinue,
    'refresh_token_already_used': AppStrings.pleaseSignInAgainToContinue,
    'over_request_rate_limit': AppStrings.tooManyAttemptsPleaseTryAgainLater,
    'over_email_send_rate_limit':
        AppStrings.tooManyEmailsRequestedPleaseTryAgainLater,
    'over_sms_send_rate_limit':
        AppStrings.tooManyVerificationMessagesRequestedPleaseTryAgainLater,
    'request_timeout': AppStrings.theRequestTimedOutPleaseTryAgain,
  };

  static const Map<String, String> _databaseMessages = {
    '23505': AppStrings.thisRecordAlreadyExists,
    '23503': AppStrings.thisActionCouldNotBeCompletedBecauseOfRelatedRecords,
    '23502': AppStrings.someRequiredInformationIsMissing,
    '23514': AppStrings.someProvidedInformationIsInvalid,
    '22P02': AppStrings.someProvidedInformationHasAnInvalidFormat,
    '42501': AppStrings.youDoNotHavePermissionToPerformThisAction,
    'PGRST301': AppStrings.pleaseSignInAgainToContinue,
    // A single-row query can fail because it returned zero OR multiple rows.
    'PGRST116': AppStrings.theRequestedDataCouldNotBeRetrievedAsExpected,
  };

  static Failure map(Object error) {
    if (error is TimeoutException) {
      return const Failure(
        message: AppStrings.theRequestTimedOutPleaseTryAgain,
        code: 'timeout',
      );
    }

    if (error is AuthException) {
      final statusCode = int.tryParse(error.statusCode ?? '');
      final message = error is AuthRetryableFetchException
          ? AppStrings.unableToReachTheServicePleaseTryAgain
          : _authMessages[error.code] ??
                _httpMessage(
                  statusCode,
                  fallback:
                      AppStrings.unableToCompleteAuthenticationPleaseTryAgain,
                );

      return Failure(
        message: message,
        code: error.code ?? 'auth_error',
        statusCode: statusCode,
      );
    }

    if (error is PostgrestException) {
      return Failure(
        message:
            _databaseMessages[error.code] ??
            AppStrings.unableToLoadOrSaveDataPleaseTryAgain,
        // Postgres codes describe database errors, not HTTP status codes.
        code: error.code ?? 'database_error',
      );
    }

    if (error is StorageException) {
      final statusCode = int.tryParse(error.statusCode ?? '');
      return Failure(
        message: _httpMessage(
          statusCode,
          fallback: AppStrings.unableToCompleteTheFileOperationPleaseTryAgain,
        ),
        code: 'storage_error',
        statusCode: statusCode,
      );
    }

    if (error is FunctionException) {
      return Failure(
        message: _httpMessage(
          error.status,
          fallback: AppStrings.unableToCompleteTheOperationPleaseTryAgain,
        ),
        code: 'function_error',
        statusCode: error.status > 0 ? error.status : null,
      );
    }

    if (error is FormatException || error is TypeError) {
      return const Failure(
        message: AppStrings.theReturnedDataCouldNotBeProcessedPleaseTryAgain,
        code: 'invalid_response',
      );
    }

    return const Failure(
      message: AppStrings.anUnexpectedErrorOccurredPleaseTryAgain,
      code: 'unexpected_error',
    );
  }

  static String _httpMessage(int? statusCode, {required String fallback}) {
    switch (statusCode) {
      case 401:
        return AppStrings.pleaseSignInAgainToContinue;
      case 403:
        return AppStrings.youDoNotHavePermissionToPerformThisAction;
      case 404:
        return AppStrings.theRequestedItemCouldNotBeFound;
      case 409:
        return AppStrings.thisActionConflictsWithExistingData;
      case 413:
        return AppStrings.theSubmittedDataIsTooLarge;
      case 429:
        return AppStrings.tooManyRequestsPleaseTryAgainLater;
      default:
        if (statusCode != null && statusCode >= 500 && statusCode < 600) {
          return AppStrings
              .theServiceIsTemporarilyUnavailablePleaseTryAgainLater;
        }
        return fallback;
    }
  }
}
