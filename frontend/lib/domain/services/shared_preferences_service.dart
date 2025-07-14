import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _avatarKey = 'user_avatar';
  static const _nameKey = 'name';
  static const _surnameKey = 'surname';
  static const _ageKey = 'age';
  static const _aliasKey = 'alias';
  static const _genderKey = 'gender';
  static const _descriptionKey = 'description';
  static const _activitiesKey = 'activities';
  static const _tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> saveAvatar(Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_avatarKey, base64Encode(bytes));
  }

  Future<Uint8List?> loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString(_avatarKey);
    if (base64Image != null) {
      return base64Decode(base64Image);
    }
    return null;
  }

  Future<void> saveProfile({
    required String name,
    required String surname,
    required String age,
    required String alias,
    required String gender,
    required String description,
    required Set<String> activities,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_surnameKey, surname);
    await prefs.setString(_ageKey, age);
    await prefs.setString(_aliasKey, alias);
    await prefs.setString(_genderKey, gender);
    await prefs.setString(_descriptionKey, description);
    await prefs.setStringList(_activitiesKey, activities.toList());
  }

  Future<Map<String, dynamic>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? '',
      'surname': prefs.getString(_surnameKey) ?? '',
      'age': prefs.getString(_ageKey) ?? '',
      'alias': prefs.getString(_aliasKey) ?? '',
      'gender': prefs.getString(_genderKey) ?? 'Ж',
      'description': prefs.getString(_descriptionKey) ?? '',
      'activities': prefs.getStringList(_activitiesKey) ?? [],
    };
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_surnameKey);
    await prefs.remove(_ageKey);
    await prefs.remove(_aliasKey);
    await prefs.remove(_genderKey);
    await prefs.remove(_descriptionKey);
    await prefs.remove(_activitiesKey);
    await prefs.remove(_avatarKey);
  }

  Future<String?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode');
  }

  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', theme);
  }
}
