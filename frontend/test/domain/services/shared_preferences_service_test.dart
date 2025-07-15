import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/domain/services/shared_preferences_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saveToken and loadToken', () async {
    final service = SharedPreferencesService();
    await service.saveToken('token123');
    final token = await service.loadToken();
    expect(token, 'token123');
    await service.clearToken();
    final cleared = await service.loadToken();
    expect(cleared, isNull);
  });

  test('saveAvatar and loadAvatar', () async {
    final service = SharedPreferencesService();
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    await service.saveAvatar(bytes);
    final loaded = await service.loadAvatar();
    expect(loaded, bytes);
  });

  test('saveProfile and loadProfile', () async {
    final service = SharedPreferencesService();
    await service.saveProfile(
      name: 'John',
      surname: 'Doe',
      age: '30',
      alias: 'jdoe',
      gender: 'M',
      description: 'desc',
      activities: {'run', 'swim'},
    );
    final profile = await service.loadProfile();
    expect(profile['name'], 'John');
    expect(profile['surname'], 'Doe');
    expect(profile['age'], '30');
    expect(profile['alias'], 'jdoe');
    expect(profile['gender'], 'M');
    expect(profile['description'], 'desc');
    expect(profile['activities'], contains('run'));
    expect(profile['activities'], contains('swim'));
    await service.clearProfile();
    final cleared = await service.loadProfile();
    expect(cleared['name'], '');
    expect(cleared['activities'], isEmpty);
  });

  test('saveTheme and loadTheme', () async {
    final service = SharedPreferencesService();
    await service.saveTheme('dark');
    final theme = await service.loadTheme();
    expect(theme, 'dark');
  });
}
