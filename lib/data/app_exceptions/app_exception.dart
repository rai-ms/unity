import '../../utils/app_helper/app_strings.dart';

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class InternetException extends AppException {
  InternetException([String? message]) {
    AppException(message, AppStrings.noInternet);
  }
}

class RequestTimeOut extends AppException {
  RequestTimeOut([String? message]) {
    AppException(message, AppStrings.requestTimeOut);
  }
}

class ServerException extends AppException {
  ServerException([String? message]) {
    AppException(message, AppStrings.serverError);
  }
}

class DatabaseException extends AppException {
  DatabaseException([String? message]) {
    AppException(message, AppStrings.databaseError);
  }
}

class InvalidUrl extends AppException {
  InvalidUrl([String? message]) {
    AppException(message, AppStrings.invalidUrl);
  }
}

class UnauthorizedAccessException extends AppException {
  UnauthorizedAccessException([String? message]) {
    AppException(message, AppStrings.invalidUser);
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) {
    AppException(message, AppStrings.errorOccured);
  }
}

class UnableToConvert extends AppException {
  UnableToConvert([String? message]) {
    AppException(message, AppStrings.errorDataType);
  }
}

class UnableToLogin extends AppException {
  UnableToLogin([String? message]) {
    AppException(message, AppStrings.errorLogin);
  }
}
