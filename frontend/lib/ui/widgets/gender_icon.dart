import 'package:flutter/material.dart';

class GenderIcon extends StatelessWidget {
  final String? gender;
  const GenderIcon({super.key, this.gender = ''});

  @override
  Widget build(BuildContext context) {
    if (gender == 'М') {
      //TODO: update russian letters
      return const Icon(Icons.male, color: Colors.blue);
    } else if (gender == 'Ж') {
      return const Icon(Icons.female, color: Colors.pink);
    } else {
      return Container();
    }
  }
}
