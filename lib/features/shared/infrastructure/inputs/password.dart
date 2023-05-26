import 'package:formz/formz.dart';

import '../../../../config/config.dart' as config;

// Define input validation errors
enum PasswordError { empty, length, format }

// Extend FormzInput and provide the input type and error type.
class Password extends FormzInput<String, PasswordError> {
  // Call super.pure to represent an unmodified form input.
  const Password.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Password.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordError.empty) return config.errorEmpty;
    if (displayError == PasswordError.length) return config.errorLength;
    if (displayError == PasswordError.format) return config.errorPasswordFormat;

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 6) return PasswordError.length;
    if (!config.passwordRegExp.hasMatch(value)) return PasswordError.format;

    return null;
  }
}
