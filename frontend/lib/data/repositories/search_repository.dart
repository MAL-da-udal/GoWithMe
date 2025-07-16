import 'package:frontend/data/api/api_client.dart';
import 'package:frontend/data/models/user.dart';
import 'package:frontend/domain/services/shared_preferences_service.dart';

class SearchRepository {
  final ApiClient apiClient;
  final SharedPreferencesService prefs;

  SearchRepository(this.apiClient, this.prefs);

  Future<List<String>> getInterestCategories() async {
    final response = await apiClient.dio.get('/interests/cats');
    final data = response.data['details'];
    return List<String>.from(data);
  }

  Future<List<User>> searchUsersByInterests(List<String> interests) async {
    if (interests.isEmpty) {
      return [];
    }
    final interestsString = interests.join(';');
    final response = await apiClient.dio.get(
      '/interests/all',
      queryParameters: {
        'page_num': 1,
        'page_size': 100, // TODO: change
        'interests': interestsString,
      },
    );

    final usersMap = response.data['users'] as Map<String, dynamic>;
    final users = usersMap.values
        .map((userJson) => User.fromJson(userJson))
        .toList();
    int? id = await getId();
    users.removeWhere((user) => user.id == id);

    return users;
  }

  Future<int> getId() async {
    final response = await apiClient.dio.get('/auth/');
    final data = response.data;
    prefs.saveId(data['user_id']);
    return data['user_id'];
  }
}
