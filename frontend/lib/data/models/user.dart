import 'dart:typed_data';

class User {
  final String name;
  final String surname;
  final int age;
  final List<String> interests;
  final int id;
  final String? gender;
  final String? description;
  final String? telegram;
  Uint8List? avatarBytes;

  User({
    required this.name,
    required this.surname,
    required this.age,
    required this.interests,
    required this.id,
    required this.gender,
    required this.description,
    required this.telegram,
    this.avatarBytes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    final interests = List<String>.from(json['interests'] ?? []);
    return User(
      name: profile['name'],
      surname: profile['surname'],
      age: profile['age'],
      interests: interests,
      id: profile['user_id'],
      gender: profile['gender'],
      description: profile['description'],
      telegram: profile['telegram'],
    );
  }
}
