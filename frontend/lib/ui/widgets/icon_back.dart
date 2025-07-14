import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IconBack extends StatelessWidget {
  final VoidCallback? callback;
  const IconBack({super.key, this.callback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (callback != null) {
          callback!();
        } else {
          context.go('/home');
        }
      },
      icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
    );
  }
}
