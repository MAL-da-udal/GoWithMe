import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/domain/providers/theme_provider.dart';
import 'package:frontend/ui/widgets/icon_back.dart';
import 'package:frontend/ui/widgets/logout_button.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  bool get isCupertino => !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    if (isCupertino) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'settings.settings'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => context.go('/home/1'),
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'settings.theme'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              CupertinoFormSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  CupertinoFormRow(
                    prefix: Text('settings.system'.tr()),
                    child: CupertinoSwitch(
                      value: themeMode == ThemeMode.system,
                      onChanged: (val) {
                        if (val) themeNotifier.setTheme(ThemeMode.system);
                      },
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Text('settings.light'.tr()),
                    child: CupertinoSwitch(
                      value: themeMode == ThemeMode.light,
                      onChanged: (val) {
                        if (val) themeNotifier.setTheme(ThemeMode.light);
                      },
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Text('settings.dark'.tr()),
                    child: CupertinoSwitch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (val) {
                        if (val) themeNotifier.setTheme(ThemeMode.dark);
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 24)),
              Text(
                'settings.language'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              CupertinoFormSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  CupertinoListTile(
                    title: Text(
                      'Русский 🇷🇺',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    trailing: context.locale.languageCode == 'ru'
                        ? Icon(
                            CupertinoIcons.check_mark,
                            color: CupertinoColors.activeBlue,
                          )
                        : null,
                    onTap: () => context.setLocale(Locale('ru')),
                  ),
                  CupertinoListTile(
                    title: Text(
                      'English 🇺🇸',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: context.locale.languageCode == 'en'
                        ? Icon(
                            CupertinoIcons.check_mark,
                            color: CupertinoColors.activeBlue,
                          )
                        : null,
                    onTap: () => context.setLocale(Locale('en')),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              LogoutButton(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings.settings'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconBack(callback: () => context.go('/home/1')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'settings.theme'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),

          RadioListTile(
            title: Text('settings.system'.tr()),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) async {
              if (mode != null) {
                await themeNotifier.setTheme(mode);
              }
            },
          ),
          RadioListTile(
            title: Text('settings.light'.tr()),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) async {
              if (mode != null) {
                await themeNotifier.setTheme(mode);
              }
            },
          ),
          RadioListTile(
            title: Text('settings.dark'.tr()),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) async {
              if (mode != null) {
                await themeNotifier.setTheme(mode);
              }
            },
          ),
          Padding(padding: EdgeInsets.only(top: 24)),
          Text(
            'settings.language'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ListTile(
            leading: Text('🇷🇺'),
            title: Text('Русский'),
            onTap: () => context.setLocale(Locale('ru')),
          ),
          ListTile(
            leading: Text('🇺🇸'),
            title: Text('English'),
            onTap: () => context.setLocale(Locale('en')),
          ),
          Padding(padding: EdgeInsets.only(top: 16)),

          LogoutButton(),
        ],
      ),
    );
  }
}
