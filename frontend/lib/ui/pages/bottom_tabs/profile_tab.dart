import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String name = '';
  String gender = 'Ж';
  int age = 0;
  String description = '';
  Set<String> selectedActivities = {};
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final descriptionController = TextEditingController();

  final activities = [
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: Text(name == '' ? "" : name[0].toUpperCase()),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Имя'),
          ),

          TextField(
            controller: surnameController,
            decoration: const InputDecoration(labelText: 'Фамилия'),
          ),

          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: 'Возраст'),
            keyboardType: TextInputType.number,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Ж'),
                selected: gender == 'Ж',
                onSelected: (_) => setState(() => gender = 'Ж'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('М'),
                selected: gender == 'М',
                onSelected: (_) => setState(() => gender = 'М'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Описание',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activities.map((act) {
              final isSelected = selectedActivities.contains(act);
              return FilterChip(
                label: Text(act),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    isSelected
                        ? selectedActivities.remove(act)
                        : selectedActivities.add(act);
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              //TODO: add implementation
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }
}
