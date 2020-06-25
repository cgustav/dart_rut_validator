import 'package:flutter_test/flutter_test.dart';
import 'package:dart_rut_validator/dart_rut_validator.dart';

import 'determiner.dart';

void main() {
  group('VALIDATION', () {
    final determiner = Determiner();

    test('All RUT are valids', () {
      expect(determiner.getFailedValues(), []);
    });
  });
}
