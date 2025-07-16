import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_with_me/domain/providers/search_provider.dart';
import 'package:go_with_me/domain/services/app_services.dart';
import 'package:go_with_me/ui/widgets/custom_filter_chip.dart';
import 'package:go_with_me/ui/widgets/gender_icon.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  @override
  void initState() {
    super.initState();
    _loadInterests();
    ref.read(searchProvider).reset();
  }

  Future<void> _loadInterests() async {
    final cats = await searchRepository.getInterestCategories();
    ref.read(searchProvider).setInterests(cats);
  }

  Future<void> _searchUsers() async {
    final selected = ref.watch(searchProvider).selected;
    final users = await searchRepository.searchUsersByInterests(selected);
    ref.read(searchProvider).setUsers(users);
    ref.read(searchProvider).search();
  }

  @override
  Widget build(BuildContext context) {
    final interests = ref.watch(searchProvider).interests;
    final selected = ref.watch(searchProvider).selected;
    final users = ref.watch(searchProvider).users;
    final search = ref.watch(searchProvider);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 16),
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

          ElevatedButton(onPressed: _searchUsers, child: Text('Найти')),
          SizedBox(height: 16),
          if (users.isEmpty && search.isSearched)
            Text('Пользователи не найдены'),

          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Row(
                      children: [
                        Text('${user.name}, ${user.age}'),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        GenderIcon(gender: user.gender),
                      ],
                    ),
                    subtitle: Text(user.interests.join(', ')),
                    onTap: () => context.push('/profile/${user.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
