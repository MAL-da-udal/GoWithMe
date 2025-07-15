import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/functions/text_to_string.dart';

void main() {
  group('themeToString', () {
    test('returns correct string for ThemeMode.light', () {
      expect(themeToString(ThemeMode.light), 'light');
    });
    test('returns correct string for ThemeMode.dark', () {
      expect(themeToString(ThemeMode.dark), 'dark');
    });
    test('returns correct string for ThemeMode.system', () {
      expect(themeToString(ThemeMode.system), 'system');
    });
  });
} 