// ignore_for_file: depend_on_referenced_packages

import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String avatarUrl;

  User({required this.name, required this.email, required this.avatarUrl});
}
