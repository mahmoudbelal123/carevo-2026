import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, StorageException;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Check your connection.']);
}

final class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed.']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Item not found.']);
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error. Please try again.']);
}

final class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input.']);
}

final class FileTooLargeException extends AppException {
  const FileTooLargeException([super.message = 'File is too large. Maximum 5 MB.']);
}

AppException mapSupabaseError(Object error) {
  if (error is PostgrestException) {
    return switch (error.code) {
      '42501' => const AuthException('Permission denied.'),
      'PGRST116' => const NotFoundException(),
      _ => ServerException(error.message),
    };
  }
  if (error is sb.AuthException) {
    return AuthException(error.message);
  }
  if (error is StorageException) {
    return ServerException(error.message);
  }
  return NetworkException();
}
