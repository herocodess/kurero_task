// ignore_for_file: depend_on_referenced_packages

import 'package:hive/hive.dart';
import 'package:kurero_task/core/models/user_model.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final User sender;

  MessageModel({
    required this.text,
    required this.timestamp,
    required this.sender,
  });
}
