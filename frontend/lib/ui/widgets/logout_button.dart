import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/domain/providers/search_provider.dart';
import 'package:frontend/domain/services/app_services.dart';
import 'package:easy_localization/easy_localization.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('logout.title'.tr()),
            content: Text('logout.confirm'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('logout.no'.tr()),
              ),
              TextButton(
                onPressed: () async {
                  await apiClient.clearTokens();
                  ref.read(searchProvider).resetAll();
                  await sharedPreferences.clearProfile();
                  if (context.mounted) context.go('/auth');
                },
                child: Text('logout.yes'.tr()),
              ),
            ],
          ),
        );
      },
      child: Text(
        "logout.button".tr(),
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.red, fontSize: 20),
      ),
    );
  }
}
