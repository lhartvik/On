import 'package:flutter/material.dart';
import 'package:on_app/util/util.dart';

class Statistics extends ChangeNotifier {
  DateTime? _lastMedicineTaken;
  DateTime? _lastLog;

  DateTime? get lastMedicineTaken => _lastMedicineTaken;
  DateTime? get lastLog => _lastLog;

  String get lastMedicineTakenString {
    return Util.format(_lastMedicineTaken?.toLocal());
  }

  String get lastLogString {
    return Util.format(_lastLog?.toLocal());
  }

  void updateLastMedicineTaken(DateTime? value) {
    _lastMedicineTaken = value;
    notifyListeners();
  }

  void updateLastLog(DateTime? value) {
    _lastLog = value;
    notifyListeners();
  }

  String get timeSinceLastMedicineTakenString {
    return Util.formatTidSiden(Util.timeSince(_lastMedicineTaken));
  }

  String get timeSinceLastLogString {
    return Util.formatTidSiden(Util.timeSince(_lastLog));
  }
}
