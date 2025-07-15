import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/domain/services/shared_preferences_service.dart';
import 'package:frontend/ui/widgets/custom_filter_chip.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String gender = 'Ж';
  Set<String> selectedActivities = {};
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final aliasController = TextEditingController();
  final descriptionController = TextEditingController();
  final _prefsService = SharedPreferencesService();

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

  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvatar();
      _loadProfile();
    });
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _avatarBytes = bytes);
      _prefsService.saveAvatar(bytes);
    }
  }

  Future<void> _loadAvatar() async {
    final avatar = await _prefsService.loadAvatar();
    if (avatar != null) {
      setState(() => _avatarBytes = avatar);
    }
  }

  Future<void> _loadProfile() async {
    final data = await _prefsService.loadProfile();
    setState(() {
      nameController.text = data['name'];
      surnameController.text = data['surname'];
      ageController.text = data['age'];
      aliasController.text = data['alias'];
      gender = data['gender'];
      descriptionController.text = data['description'];
      selectedActivities = Set<String>.from(data['activities']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    context.go('/settings');
                  },
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: _pickAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarBytes != null
                        ? MemoryImage(_avatarBytes!)
                        : null,
                    child: _avatarBytes == null
                        ? const Icon(Icons.upload, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Имя'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: surnameController,
                  decoration: InputDecoration(labelText: 'Фамилия'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Возраст'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: aliasController,
                  decoration: InputDecoration(
                    labelText: 'Telegram',
                    prefixText: '@',
                    hintText: 'username',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('Ж'),
                      selected: gender == 'Ж',
                      onSelected: (_) => setState(() => gender = 'Ж'),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: gender == 'Ж'
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('М'),
                      selected: gender == 'М',
                      onSelected: (_) => setState(() => gender = 'М'),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: gender == 'М'
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Описание'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: activities.map((act) {
                    final isSelected = selectedActivities.contains(act);
                    return CustomFilterChip(
                      label: act,
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
                  onPressed: () async {
                    await _prefsService.saveProfile(
                      name: nameController.text,
                      surname: surnameController.text,
                      age: ageController.text,
                      alias: aliasController.text,
                      gender: gender,
                      description: descriptionController.text,
                      activities: selectedActivities,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Профиль сохранен')));
                  },
                  child: Text("Сохранить"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
