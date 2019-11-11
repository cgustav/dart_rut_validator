library dart_rut_validator;

import 'package:flutter/material.dart';

class RUTValidator {
  int numeros;
  String digitoVerificador;
  String validationErrorText;

  RUTValidator(
      {int numero, String digitoVerificador, String validationErrorText}) {
    this.numeros = numero ?? 0;
    this.digitoVerificador = digitoVerificador?.toUpperCase() ?? '';
    this.validationErrorText = validationErrorText ?? 'RUT no válido.';
  }

  ///Retorna el valor del digito verificador [String]
  ///en base a los números que componen la cadena de
  ///Strings mediante el calculo Mod 11.
  String get digitoVerificado => _RUTValidatorUtils._calcMod11(this.numeros);

  ///Retorna la validez
  bool get esValido =>
      (_RUTValidatorUtils._calcMod11(this.numeros) == this.digitoVerificador);

  ///Obtiene dígito verificador a partir de un RUT con formato de
  ///puntos y guiones.
  static String getRutDV(String rutString) => _getRUTElements(rutString)[1];

  ///Obtiene los elementos numéricos que componen
  ///el RUT, excluyendo el digito verificador.
  static int getRutNumbers(String rutString) =>
      int.parse(_getRUTElements(rutString)[0]);

  ///Obtiene array con los elementos numéricos del RUT (index 0)
  ///y el digito verificador (index 1).
  static List<String> _getRUTElements(String rutString) =>
      rutString.split('.').join('').split('-');

  ///Valida la validez de rut en base al cálculo de
  ///su dígito verificador y otros criterios.
  String validate(String value) {
    print('VALIDATING...');
    value = formatFromText(value);
    print('INCOMING VALUE : $value');
    try {
      this.numeros = getRutNumbers(value);
      this.digitoVerificador = getRutDV(value);
      print('NUMEROS $numeros');
      print('DV $digitoVerificador');
    } catch (e) {
      return this.validationErrorText;
    }

    return (value == null ||
            value.length <= 10 ||
            this.numeros < 1000000 ||
            !this.esValido)
        ? this.validationErrorText
        : null;
  }

//----------------------------------------
// Formatters

  static String formatFromText(String value) {
    value = deFormat(value);
    return (value.length <= 8)
        ? _RUTValidatorUtils._shortVersionFormat(value)
        : _RUTValidatorUtils._longVersionFormat(value);
  }

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

  static String deFormat(String value) {
    return value.split('.').join('').split('-').join('');
  }

  //Internals

  //static String _applyFormat(String value) {}
}

class _RUTValidatorUtils {
  static String _calcMod11(int nums) {
    final String stringNumero = nums.toString();
    final List<int> factors = [3, 2, 7, 6, 5, 4, 3, 2];
    int indiceFactor = factors.length - 1;
    int calc = 0;

    for (int i = stringNumero.length - 1; i >= 0; i--) {
      calc += (factors[indiceFactor] * int.parse(stringNumero[i]));
      indiceFactor--;
    }
    int result = 11 - (calc % 11);

    return (result == 11 || result == 10) ? '0' : result.toString();
  }

  // static _checkIfRUTIsFormatted(String text) =>
  //     (text.contains(RegExp(r'\.')) || text.contains(RegExp(r'\-')));

  static String _shortVersionFormat(String input) {
    List<String> output = [];
    Map<int, String> mp = {1: '.', 4: '.', 7: '-'};

    for (int i = 0; i < input.length; i++) {
      if (mp.containsKey(i)) output.add(mp[i]);
      output.add(input[i]);
    }

    return output.join('');
  }

  static String _longVersionFormat(String text) =>
      '${text[0]}${text[1]}.${text[2]}${text[3]}'
      '${text[4]}.${text[5]}${text[6]}${text[7]}'
      '-${text[8]}';
}
