import 'package:frontend/data/repositories/profile_repository.dart';
import 'package:frontend/data/repositories/search_repository.dart';
import 'package:frontend/domain/services/shared_preferences_service.dart';
import '../../data/api/api_client.dart';
import '../../data/repositories/auth_repository.dart';

final apiClient = ApiClient();

final authRepository = AuthRepository(apiClient);

final profileRepository = ProfileRepository(apiClient, sharedPreferences);
final searchRepository = SearchRepository(apiClient, sharedPreferences);

final sharedPreferences = SharedPreferencesService();
