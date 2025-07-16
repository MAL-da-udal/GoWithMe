import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/domain/providers/search_provider.dart';
import 'package:frontend/domain/services/app_services.dart';
import 'package:frontend/ui/widgets/custom_filter_chip.dart';
import 'package:frontend/ui/widgets/gender_icon.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    if (ref.read(searchProvider).interests.isEmpty) {
      _loadInterests();
    }
    ref.read(searchProvider).reset();
  }

  Future<void> _loadInterests() async {
    final search = ref.read(searchProvider);
    search.startLoadingInterests();
    final cats = await searchRepository.getInterestCategories();
    ref.read(searchProvider).setInterests(cats);
  }

  Future<void> _searchUsers() async {
    final search = ref.read(searchProvider);
    search.startLoading();
    final selected = ref.watch(searchProvider).selected;
    final users = await searchRepository.searchUsersByInterests(selected);
    await search.setUsers(users);
    search.search();
    search.stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    final interests = ref.watch(searchProvider).interests;
    final selected = ref.watch(searchProvider).selected;
    final users = ref.watch(searchProvider).users;
    final search = ref.watch(searchProvider);
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (interests.isEmpty && search.isLoadingInterests)
            Center(child: CircularProgressIndicator()),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) {
              final isSelected = selected.contains(interest);

              return CustomFilterChip(
                label: interest,
                selected: isSelected,
                onSelected: (_) {
                  isSelected
                      ? search.removeSelected(interest)
                      : search.addSelected(interest);
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(onPressed: _searchUsers, child: Text('Найти')),
              ],
            ),
          ),
          SizedBox(height: 16),
          if (users.isEmpty && search.isSearched && !search.isLoading)
            Text('Пользователи не найдены'),
          if (search.isLoading) Center(child: CircularProgressIndicator()),

          ...users.map((user) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatarBytes != null
                      ? MemoryImage(user.avatarBytes!)
                      : null,
                  child: user.avatarBytes == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Row(
                  children: [
                    Text('${user.name}, ${user.age}'),
                    const SizedBox(width: 5),
                    GenderIcon(gender: user.gender),
                  ],
                ),
                subtitle: Text(user.interests.join(', ')),
                onTap: () {
                  ref.read(searchProvider).setCurrentUser(user);
                  context.push('/profile/${user.id}');
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
