class ConnectionError implements Exception {}

class InvalidToken implements Exception {}

class WrongCredentials implements Exception {}

class CustomError implements Exception {
  final String message;
  final bool loggedRequired;
  // final int statusCode;
  CustomError(this.message, [this.loggedRequired = false]);
}
