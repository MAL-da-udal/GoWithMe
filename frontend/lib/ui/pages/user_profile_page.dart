import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfilePage extends StatefulWidget {
  final String token;
  const UserProfilePage({super.key, required this.token});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User profile page"),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: const Icon(Icons.arrow_back, size: 24),
        ),
      ),
      body: Center(child: Text('Profile with token: ${widget.token}')),
    );
  }
}
