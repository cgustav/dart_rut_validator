library dart_rut_validator;

import 'package:flutter/material.dart';

class RUTValidator {
  int numeros;
  String digitoVerificador;

  RUTValidator({int numero, String digitoVerificador}) {
    this.numeros = numero;
    this.digitoVerificador = digitoVerificador.toUpperCase();
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
  static String validator(String value, {bool isFormatted = true}) {
    //String textInput = (!isFormatted) ? _applyFormat(value) : value;
  }

//----------------------------------------
// Formatters

  static String formatFromText(String value) {
    if (_RUTValidatorUtils._checkIfRUTIsFormatted(value))
      print('RUT CON FORMATO');
    else
      print('RUT SIN FORMATO');
  }

  static void formatFromTextController(TextEditingController controller) {
    TextEditingValue oldValue =
        TextEditingValue(text: deFormat(controller.text));
    TextEditingValue newValue;
    String finalValue;

    if (oldValue.text.length > 8) {
      finalValue =
          '${oldValue.text[0]}${oldValue.text[1]}.${oldValue.text[2]}${oldValue.text[3]}'
          '${oldValue.text[4]}.${oldValue.text[5]}${oldValue.text[6]}${oldValue.text[7]}'
          '-${oldValue.text[8]}';
    } else if (oldValue.text.length <= 8) {
      List<String> outSt = [];
      Map<int, String> mp = {1: '.', 4: '.', 7: '-'};

      for (int i = 0; i < oldValue.text.length; i++) {
        if (mp.containsKey(i)) outSt.add(mp[i]);
        outSt.add(oldValue.text[i]);
      }

      finalValue = outSt.join('');
    }

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

  static _checkIfRUTIsFormatted(String text) =>
      (text.contains(RegExp(r'\.')) /*|| text.contains(RegExp(r'\-\.'))*/);
}

// class RUTFieldValidator {
//   static String validate(String value) {
//     try {
//       MODValidator rut = MODValidator(
//           numero: MODValidator.getRutNumbers(value),
//           digitoVerificador: MODValidator.getRutDV(value));

//       /* DEBUG
//       print('DV VERIFICADO: ${rut.dVCalculado}');
//       print('El rut es $value');
//       print('El length es ${value.length}');
//       */
//       //RegExp criteria = RegExp(r'^\d{1,2}\.\d{3}\.\d{3}[-][0-9kK]{1}$');

//       return (value.length <= 10 || value.isEmpty || !rut.esValido)
//           ? 'RUT No válido'
//           : null;
//     } catch (e) {
//       return 'RUT No válido';
//     }
//   }
// }
