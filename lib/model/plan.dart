import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Plan {
  late String id;
  final String medicine;
  final TimeOfDay time;

  String get tidString =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Plan({String? id, required this.medicine, required this.time})
      : id = id ?? uuid.v4();

  factory Plan.fromJsonDatabase(Map<String, dynamic> jsonObject) {
    final String id = jsonObject['id'] as String;
    final String timeString = jsonObject['time'] as String;

    final hour = int.parse(timeString.split(':')[0]);
    final minute = int.parse(timeString.split(':')[1]);

    final tid = TimeOfDay(hour: hour, minute: minute);
    return Plan(id: id, medicine: jsonObject['medicine'] as String, time: tid);
  }
}
