import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:go_with_me/data/api/api_client.dart';
import 'package:go_with_me/domain/services/shared_preferences_service.dart';

class ProfileRepository {
  final SharedPreferencesService prefs;
  final ApiClient apiClient;

  ProfileRepository(this.apiClient, this.prefs);

  Future<Map<String, dynamic>> loadCachedProfile() async {
    return await prefs.loadProfile();
  }

  Future<Map<String, dynamic>> fetchAndCacheProfile() async {
    final response = await apiClient.dio.get('/profile');
    final interests = await getUserInterests();
    final data = response.data;

    await prefs.saveProfile(
      name: data['name'],
      surname: data['surname'],
      age: data['age'].toString(),
      alias: data['telegram'],
      gender: data['gender'],
      description: data['description'],
      activities: interests,
    );

    return data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await apiClient.dio.get('/profile/');
    return response.data;
  }

  Future<void> updateProfile(
    String name,
    String surname,
    String age,
    String alias,
    String gender,
    String description,
    List<String> activities,
  ) async {
    final data = {
      'name': name,
      'surname': surname,
      'age': int.tryParse(age) ?? 0,
      'telegram': alias,
      'gender': gender,
      'description': description,
      'id': 0,
      'user_id': 0,
    };
    await apiClient.dio.patch('/profile/', data: data);
    await updateUserInterests(activities);

    await prefs.saveProfile(
      name: name,
      surname: surname,
      age: age,
      alias: alias,
      gender: gender,
      description: description,
      activities: activities,
    );
  }

  Future<void> createProfile() async {
    final data = {
      "id": 0,
      "user_id": 0,
      "name": "",
      "surname": "",
      "gender": "",
      "telegram": "",
      "age": 0,
      "description": "",
    };
    await apiClient.dio.post('/profile/', data: data);
  }

  Future<List<String>> getUserInterests() async {
    final response = await apiClient.dio.get('/interests/');
    final data = response.data;
    return List<String>.from(data['details'] ?? []);
  }

  Future<void> updateUserInterests(List<String> interests) async {
    final body = {'interests': interests};
    await apiClient.dio.put('/interests/', data: body);
  }

  Future<void> uploadAvatar(Uint8List bytes) async {
    if (bytes.length > 2 * 1024 * 1024) {
      throw Exception('Avatar file is too large');
    }
    final formData = FormData.fromMap({
      'avatar': MultipartFile.fromBytes(bytes, filename: 'image.png'),
    });

    await apiClient.dio.put('/avatar/', data: formData);

    await SharedPreferencesService().saveAvatar(bytes);
  }

  Future<Uint8List?> fetchAvatar(int? userId) async {
    try {
      final response = await apiClient.dio.get<List<int>>(
        '/avatar',
        queryParameters: {'user_id': userId},
        options: Options(
          responseType: ResponseType.bytes,
          extra: {'suppressErrorNotification': true},
        ),
      );

      final bytes = Uint8List.fromList(response.data!);
      await SharedPreferencesService().saveAvatar(bytes);
      return bytes;
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) {
        rethrow;
      } else {
        return null;
      }
    }
  }
}
