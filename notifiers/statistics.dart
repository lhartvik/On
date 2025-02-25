import 'package:flutter/material.dart';
import 'package:on_app/util/util.dart';

class Statistics extends ChangeNotifier {
  DateTime? _lastMedicineTaken;

  DateTime? get lastMedicineTaken => _lastMedicineTaken;

  String get lastMedicineTakenString {
    return Util.format(_lastMedicineTaken?.toLocal()) ;
  }

  void updateLastMedicineTaken(DateTime? value) {
    _lastMedicineTaken = value;
    notifyListeners();
  }

  Duration get timeSinceLastMedicineTaken {
    final now = DateTime.now().toUtc();
    if (_lastMedicineTaken == null) {
      return Duration.zero;
    }
    return now.difference(_lastMedicineTaken!);
  }

  String get timeSinceLastMedicineTakenString {
    final duration = timeSinceLastMedicineTaken;
    return Util.formatTidSiden(duration);
  }
}
