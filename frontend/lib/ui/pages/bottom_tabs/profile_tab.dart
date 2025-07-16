import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/providers/search_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/domain/services/app_services.dart';
import 'package:frontend/domain/services/shared_preferences_service.dart';
import 'package:frontend/ui/widgets/custom_filter_chip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  String gender = 'Ж';
  List<String> selectedActivities = [];
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final ageController = TextEditingController();
  final aliasController = TextEditingController();
  final descriptionController = TextEditingController();
  final _prefsService = SharedPreferencesService();

  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAvatar();
      _loadCachedThenUpdate();
      final search = ref.read(searchProvider);
      if (search.interests.isEmpty) {
        _loadInterests();
      }
    });
  }

  Future<void> _loadInterests() async {
    final cats = await searchRepository.getInterestCategories();
    ref.read(searchProvider).setInterests(cats);
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
      ).showSnackBar(SnackBar(content: Text('profile.updateSuccess'.tr())));
    }
  }

  Future<void> _loadAvatar() async {
    final local = await _prefsService.loadAvatar();
    if (local != null) {
      if (!mounted) return;
      setState(() => _avatarBytes = local);
    }

    try {
      final fresh = await profileRepository.fetchAvatar(null);
      if (!mounted) return;
      setState(() => _avatarBytes = fresh);
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) {
        rethrow;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    ageController.dispose();
    aliasController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(searchProvider).interests;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
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
                    decoration: InputDecoration(
                      labelText: 'profile.firstName'.tr(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: surnameController,
                    decoration: InputDecoration(
                      labelText: 'profile.lastName'.tr(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: 'profile.age'.tr()),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: aliasController,
                    decoration: InputDecoration(
                      labelText: 'profile.telegram'.tr(),
                      prefixText: '@',
                      hintText: 'username',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text('profile.genderFemale'.tr()),
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
                        label: Text('profile.genderMale'.tr()),
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
                    decoration: InputDecoration(
                      labelText: 'profile.description'.tr(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activities.map((act) {
                      final isSelected = selectedActivities.contains(act);
                      return CustomFilterChip(
                        label: 'interests.$act'.tr(),
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

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('profile.updateSuccess'.tr())),
                      );
                    },
                    child: Text("profile.save".tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
