library dart_rut_validator;

import 'package:flutter/widgets.dart';

class RUTValidator {
  int numbers;
  String dv;
  String validationErrorText;

  RUTValidator({int? numbers, String? dv, String? validationErrorText})
      : this.numbers = numbers ?? 0,
        this.dv = dv?.toUpperCase() ?? '',
        this.validationErrorText = validationErrorText ?? 'RUT no válido.';

  ///Retorna el valor del digito verificador [String]
  ///en base a los números que componen la cadena de
  ///Strings mediante el calculo Mod 11.
  String get digitoVerificado => _RUTValidatorUtils._calcMod11(this.numbers);

  ///Retorna la validez de un rut de entrada
  bool get isValid => (_RUTValidatorUtils._calcMod11(this.numbers) == this.dv);

  ///Obtiene dígito verificador a partir de un RUT con formato de
  ///puntos y guiones.
  static String getRutDV(String rutString) {
    dynamic actualDV = _getRUTElements(rutString)[1];
    return (RegExp(r'[0kK]').hasMatch(actualDV)) ? '0' : actualDV;
  }

  ///Obtiene los elementos numéricos que componen
  ///el RUT, excluyendo el digito verificador.
  static int getRutNumbers(String rutString) =>
      int.parse(_getRUTElements(rutString)[0]);

  ///Obtiene array con los elementos numéricos del RUT (index 0)
  ///y el digito verificador (index 1).
  static List<String> _getRUTElements(String rutString) =>
      rutString.split('.').join('').split('-');

  ///Valida rut en base al cálculo de
  ///su dígito verificador y formato.
  String? validator(String? value) {
    if (value == null) return null;
    value = formatFromText(value);
    try {
      this.numbers = getRutNumbers(value);
      this.dv = getRutDV(value);
    } catch (e) {
      // print('RUT Validation Error: $e');
      return this.validationErrorText;
    }

    return (value.length <= 10 || this.numbers < 1000000 || !this.isValid)
        ? this.validationErrorText
        : null;
  }

//----------------------------------------
// Formatters

  ///Aplica el formato específico de RUT
  ///a partir de un texto.
  ///Formatos soportados:
  ///* xx.xxx.xxx-@
  ///* x.xxx.xxx-@
  static String formatFromText(String value) {
    value = deFormat(value);
    return (value.length <= 8)
        ? _RUTValidatorUtils._shortVersionFormat(value)
        : _RUTValidatorUtils._longVersionFormat(value);
  }

  ///Aplica el formato específico de RUT
  ///a partir de un controlador de texto.
  ///Formatos soportados:
  ///* xx.xxx.xxx-@
  ///* x.xxx.xxx-@
  static void formatFromTextController(TextEditingController controller) {
    TextEditingValue oldValue =
        TextEditingValue(text: deFormat(controller.text));
    TextEditingValue newValue;

    String finalValue = (oldValue.text.length <= 8)
        ? _RUTValidatorUtils._shortVersionFormat(oldValue.text)
        : _RUTValidatorUtils._longVersionFormat(oldValue.text);

    newValue = TextEditingValue(
        text: finalValue,
        selection: TextSelection.collapsed(offset: finalValue.length));

    controller.value = TextEditingController.fromValue(newValue).value;
    controller.selection = TextEditingController.fromValue(newValue).selection;
  }

  ///Quita el formato específico de RUT
  ///de un texto.
  ///* _Ejemplo_:
  ///```
  ///print(RUTValidator.deformat('12.933.245-2'));//129332452
  ///```
  static String deFormat(String value) {
    return value.split('.').join('').split('-').join('');
  }

  ///Quita el formato específico de RUT
  ///de un text y lo deja con el guión.
  ///```
  ///print(RUTValidator.deformat('12.933.245-2'));//12933245-2
  ///```
  static String deFormatWithHyphen(String value) {
    return value.split('.').join('');
  }
}

class _RUTValidatorUtils {
  static String _calcMod11(int nums) {
    final String stringNum = nums.toString();
    final List<int> factors = [3, 2, 7, 6, 5, 4, 3, 2];
    int indexFactor = factors.length - 1;
    int calc = 0;

    for (int i = stringNum.length - 1; i >= 0; i--) {
      calc += (factors[indexFactor] * int.parse(stringNum[i]));
      indexFactor--;
    }
    int result = 11 - (calc % 11);

    return (result == 11 || result == 10) ? '0' : result.toString();
  }

  static String _shortVersionFormat(String input) {
    List<String> output = [];
    Map<int, String> mp = {1: '.', 4: '.', 7: '-'};

    for (int i = 0; i < input.length; i++) {
      if (mp.containsKey(i)) output.add(mp[i]!);
      output.add(input[i]);
    }

    return output.join('');
  }

  static String _longVersionFormat(String text) =>
      '${text[0]}${text[1]}.${text[2]}${text[3]}'
      '${text[4]}.${text[5]}${text[6]}${text[7]}'
      '-${text[8]}';
}
