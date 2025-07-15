import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/functions/validations.dart';

String defaultPassword() => '123456';

void main() {
  group('validateLogin', () {
    test('returns error if login is empty', () {
      expect(validateLogin(''), 'Please enter a login');
    });
    test('returns null if login is not empty', () {
      expect(validateLogin('user'), null);
    });
  });

  group('validatePassword', () {
    test('returns error if password is empty', () {
      expect(validatePassword(''), 'Please enter a password');
    });
    test('returns error if password is too short', () {
      expect(validatePassword('123'), 'Password must be at least 6 characters');
    });
    test('returns null if password is valid', () {
      expect(validatePassword(defaultPassword()), null);
    });
  });

  group('validatePasswordConfirmation', () {
    test('returns error if passwords do not match', () {
      expect(validatePasswordConfirmation(defaultPassword(), '654321'), 'Passwords do not match');
    });
    test('returns error if password is empty', () {
      expect(validatePasswordConfirmation('', ''), 'Please enter a password');
    });
    test('returns null if passwords match and not empty', () {
      expect(validatePasswordConfirmation(defaultPassword(), defaultPassword()), null);
    });
  });
}
