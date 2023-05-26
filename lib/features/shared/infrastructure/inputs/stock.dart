import 'package:formz/formz.dart';

import '../../../../config/config.dart' as config;

enum StockError { empty, value, format }

class Stock extends FormzInput<int, StockError> {
  const Stock.pure() : super.pure(0);
  const Stock.dirty(int value) : super.dirty(value);
  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == StockError.empty) return config.errorEmpty;
    if (displayError == StockError.value) return config.error0;
    if (displayError == StockError.format) return config.errorDefault;
    return null;
  }

  @override
  StockError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return StockError.empty;
    }
    final isInteger = int.tryParse(value.toString()) ?? -1;
    if (isInteger == -1) return StockError.format;
    if (value < 0) return StockError.value;
    return null;
  }
}
