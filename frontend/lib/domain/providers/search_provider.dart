import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_with_me/data/models/user.dart';
import 'package:go_with_me/domain/services/app_services.dart';

final searchProvider = ChangeNotifierProvider<SearchProvider>(
  (ref) => SearchProvider(),
);

class SearchProvider extends ChangeNotifier {
  List<String> interests = [];
  List<String> selected = [];
  List<User> users = [];
  bool isSearched = false;
  User? currentUser;

  void search() {
    isSearched = true;
    notifyListeners();
  }

  void reset() {
    isSearched = false;
  }

  void setInterests(List<String> newInterests) {
    interests = newInterests;
    notifyListeners();
  }

  void addSelected(String newSelected) {
    if (!selected.contains(newSelected)) {
      selected.add(newSelected);
    }
    notifyListeners();
  }

  void removeSelected(String newSelected) {
    if (selected.contains(newSelected)) {
      selected.remove(newSelected);
    }
    notifyListeners();
  }

  Future<void> setUsers(List<User> newUsers) async {
    users = newUsers;
    await updateUserAvatars();
    notifyListeners();
  }

  void resetAll() {
    interests = [];
    selected = [];
    users = [];
    isSearched = false;
  }

  void setCurrentUser(User newUser) {
    currentUser = newUser;
    notifyListeners();
  }

  Future<void> updateUserAvatars() async {
    for (final user in users) {
      try {
        final bytes = await profileRepository.fetchAvatar(user.id);
        user.avatarBytes = bytes;
      } catch (_) {}
    }
    notifyListeners();
  }
}
