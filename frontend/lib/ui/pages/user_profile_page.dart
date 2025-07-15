import 'package:flutter/material.dart';
import 'package:frontend/data/functions/open_url.dart';
import 'package:frontend/ui/widgets/custom_filter_chip.dart';
import 'package:frontend/ui/widgets/icon_back.dart';

class UserProfilePage extends StatefulWidget {
  final String token;
  const UserProfilePage({super.key, required this.token});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final activities = ["test", "testTwo"];

  final _avatarBytes = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Профиль пользователя',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 25),
        ),
        leading: IconBack(),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: _avatarBytes != null
                    ? MemoryImage(_avatarBytes!)
                    : null,
              ),
              const SizedBox(height: 16),
              Text('Имя'),
              const SizedBox(height: 10),
              Text('Фамилия'),
              const SizedBox(height: 10),
              Text('Возраст'),
              const SizedBox(height: 10),
              Text('TG'),
              const SizedBox(height: 10),
              Text('гендер'),
              const SizedBox(height: 16),
              Text("Описание"),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: activities.map((act) {
                  return CustomFilterChip(
                    label: act,
                    selected: false,
                    onSelected: (_) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  openUrl('https://t.me/mc_lavrushka'); //TODO: change
                },
                child: Text("Написать"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
