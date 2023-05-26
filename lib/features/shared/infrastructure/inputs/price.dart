import 'package:formz/formz.dart';

import '../../../../config/config.dart' as config;

enum PriceError { empty, value, format }

class Price extends FormzInput<double, PriceError> {
  const Price.pure() : super.pure(0.0);
  const Price.dirty(double value) : super.dirty(value);
  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PriceError.empty) return config.errorEmpty;
    if (displayError == PriceError.value) return config.error0;
    return null;
  }

  @override
  PriceError? validator(double value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return PriceError.empty;
    }
    if (value < 0) return PriceError.value;
    return null;
  }
}
