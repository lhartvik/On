import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum LoggType {
  medicineTaken("Ta medisin", "Opptak", Colors.black),
  on("On", "On", Colors.green),
  off("Off", "Off", Colors.red),
  dyskinesia("Dyskinesi", "Dyskinesi", Colors.orange),
  none("Ingen", "Ingen", Colors.transparent),
  error("Error", "?", Colors.grey);

  final String name;
  final String shortName;
  final Color color;

  const LoggType(this.name, this.shortName, this.color);

  static LoggType of(String? s) {
    return LoggType.values.firstWhereOrNull((element) => element.name == s) ?? LoggType.error;
  }

  static String short(LoggType event) {
    switch (event) {
      case LoggType.medicineTaken:
        return 'Opptak';
      case LoggType.on:
        return 'On';
      case LoggType.off:
        return 'Off';
      case LoggType.dyskinesia:
        return 'Dyskinesi';
      default:
        return '?';
    }
  }

  static Color colorOf(LoggType event) {
    return event.color;
  }
}
