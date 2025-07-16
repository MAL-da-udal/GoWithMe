import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/domain/services/app_services.dart';
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
  List<String> selectedActivities = [];
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final aliasController = TextEditingController();
  final descriptionController = TextEditingController();
  final _prefsService = SharedPreferencesService();

  final activities = ['swimming', 'bicycle'];

  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvatar();
      _loadCachedThenUpdate();
    });
  }

  Future<void> _loadCachedThenUpdate() async {
    final cached = await profileRepository.loadCachedProfile();
    _applyProfileToUI(cached, null);

    try {
      final updated = await profileRepository.fetchAndCacheProfile();
      final activities = await profileRepository.getUserInterests();
      _applyProfileToUI(updated, activities);
    } catch (e) {
      // print("Ошибка загрузки профиля с сервера: $e");
    }
  }

  void _applyProfileToUI(Map<String, dynamic> data, List<String>? activities) {
    setState(() {
      nameController.text = data['name'];
      surnameController.text = data['surname'];
      ageController.text = data['age'] == 0 ? '' : data['age'].toString();
      aliasController.text = data['telegram'];
      gender = data['gender'];
      descriptionController.text = data['description'];
      selectedActivities = data['activities'] == null
          ? activities ?? []
          : List<String>.from(data['activities']);
    });
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _avatarBytes = bytes);
      await profileRepository.uploadAvatar(bytes);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Профиль обновлён')));
    }
  }

  Future<void> _loadAvatar() async {
    final local = await _prefsService.loadAvatar();
    if (local != null) {
      setState(() => _avatarBytes = local);
    }

    try {
      final fresh = await profileRepository.fetchAvatar(null);
      setState(() => _avatarBytes = fresh);
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) {
        rethrow;
      }
    }
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
                const SizedBox(height: 15),
                TextField(
                  controller: surnameController,
                  decoration: InputDecoration(labelText: 'Фамилия'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Возраст'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
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
                            ? Colors.white
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
                            ? Colors.white
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
                    await profileRepository.updateProfile(
                      nameController.text,
                      surnameController.text,
                      ageController.text,
                      aliasController.text,
                      gender,
                      descriptionController.text,
                      selectedActivities,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Профиль обновлён')));
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
