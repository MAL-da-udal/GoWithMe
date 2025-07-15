import 'dart:io' show Platform;

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
            'Настройки',
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
              Text('Тема', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              CupertinoFormSection.insetGrouped(
                backgroundColor: Colors.transparent,
                children: [
                  CupertinoFormRow(
                    prefix: Text('Системная'),
                    child: CupertinoSwitch(
                      value: themeMode == ThemeMode.system,
                      onChanged: (val) {
                        if (val) themeNotifier.setTheme(ThemeMode.system);
                      },
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Text('Светлая'),
                    child: CupertinoSwitch(
                      value: themeMode == ThemeMode.light,
                      onChanged: (val) {
                        if (val) themeNotifier.setTheme(ThemeMode.light);
                      },
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: Text('Тёмная'),
                    child: CupertinoSwitch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (val) {
                        if (val) themeNotifier.setTheme(ThemeMode.dark);
                      },
                    ),
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
        title: Text('Настройки'),
        leading: IconBack(callback: () => context.go('/home/1')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Тема', style: Theme.of(context).textTheme.titleLarge),

          RadioListTile(
            title: Text('Системная'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (mode) async {
              if (mode != null) {
                await themeNotifier.setTheme(mode);
              }
            },
          ),
          RadioListTile(
            title: Text('Светлая'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (mode) async {
              if (mode != null) {
                await themeNotifier.setTheme(mode);
              }
            },
          ),
          RadioListTile(
            title: Text('Тёмная'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (mode) async {
              if (mode != null) {
                await themeNotifier.setTheme(mode);
              }
            },
          ),
          Padding(padding: EdgeInsets.only(top: 16)),

          LogoutButton(),
        ],
      ),
    );
  }
}
