import 'package:flutter/material.dart';
import 'package:on_app/util/util.dart';

class StatisticsCloud extends ChangeNotifier {
  DateTime? _lastLog;

  DateTime? get lastLog => _lastLog;

  String get lastLogString {
    return Util.format(_lastLog?.toLocal());
  }

  void updateLastLog(DateTime? value) {
    _lastLog = value;
    notifyListeners();
  }

  Duration get timeSinceLastLog {
    final now = DateTime.now().toUtc();
    if (_lastLog == null) {
      return Duration.zero;
    }
    return now.difference(_lastLog!);
  }

  String get timeSinceLastLogString {
    final duration = timeSinceLastLog;
    return Util.formatTidSiden(duration);
  }
}
