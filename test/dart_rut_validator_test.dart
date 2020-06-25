import 'package:flutter_test/flutter_test.dart';
import 'determiner.dart';

void main() {
  group('VALIDATION', () {
    final determiner = Determiner();

    test('All RUT are valids', () {
      expect(determiner.getFailedValues(), []);
    });
  });
}
