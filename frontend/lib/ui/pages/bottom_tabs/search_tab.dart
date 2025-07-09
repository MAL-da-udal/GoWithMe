import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<String> interests = [];
  List<String> selected = [];
  List<UserPreview> users = [];

  @override
  void initState() {
    super.initState();
    _loadInterests();
  }

  Future<void> _loadInterests() async {
    // TODO: Change to request /interests/cats
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      interests = [
        'Йога',
        'Бег',
        'Велосипед',
        'Плавание',
        'Футбол',
        'Танцы',
        'Питание',
        'Медитация',
        'Походы',
      ];
    });
  }

  Future<void> _searchUsers() async {
    // TODO: Change to request  /interests/all or request with selected interests
    setState(() {
      users = [
        UserPreview(
          name: 'Марина',
          age: 23,
          interests: ['Йога', 'Плавание'],
          token: "test",
        ),
        UserPreview(name: 'Лёня', age: 25, interests: ['Футбол'], token: "52x"),
        UserPreview(
          name: 'Саша',
          age: 22,
          interests: ['Плавание'],
          token: "xxx",
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            final isSelected = selected.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  isSelected
                      ? selected.remove(interest)
                      : selected.add(interest);
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 16),

        ElevatedButton(onPressed: _searchUsers, child: Text('Найти')),
        SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text('${user.name}, ${user.age}'),
                  subtitle: Text(user.interests.join(', ')),
                  onTap: () => context.push('/profile/${user.token}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class UserPreview {
  final String name;
  final int age;
  final List<String> interests;
  final String token;

  UserPreview({
    required this.name,
    required this.age,
    required this.interests,
    this.token = "x",
  });
}
