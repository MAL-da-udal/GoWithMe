import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_with_me/data/models/user.dart';

final searchProvider = ChangeNotifierProvider<SearchProvider>(
  (ref) => SearchProvider(),
);

class SearchProvider extends ChangeNotifier {
  List<String> interests = [];
  List<String> selected = [];
  List<User> users = [];
  bool isSearched = false;

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

  void setUsers(List<User> newUsers) {
    users = newUsers;
    notifyListeners();
  }

  void resetAll() {
    interests = [];
    selected = [];
    users = [];
    isSearched = false;
  }
}
