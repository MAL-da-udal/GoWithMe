import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/functions/open_url.dart';
import 'package:frontend/domain/providers/search_provider.dart';
import 'package:frontend/ui/widgets/custom_filter_chip.dart';
import 'package:frontend/ui/widgets/gender_icon.dart';
import 'package:frontend/ui/widgets/icon_back.dart';
import 'package:easy_localization/easy_localization.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  final String token;
  const UserProfilePage({super.key, required this.token});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(searchProvider).currentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconBack(),
        title: Text(
          'userProfile.title'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: user?.avatarBytes != null
                    ? MemoryImage(user!.avatarBytes!)
                    : null,
                child: user?.avatarBytes == null
                    ? Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                '${user!.name} ${user.surname}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${user.age} ${'userProfile.yearsOld'.tr()}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 8),
                  GenderIcon(gender: user.gender),
                ],
              ),
              const SizedBox(height: 20),
              if (user.description != null && user.description!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryFixed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    user.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'userProfile.interests'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: user.interests.map((act) {
                  return CustomFilterChip(
                    label: 'interests.$act'.tr(),
                    selected: false,
                    onSelected: (_) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  openUrl('https://t.me/${user.telegram}');
                },
                icon: const Icon(Icons.telegram),
                label: Text("userProfile.messageOnTelegram".tr()),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
