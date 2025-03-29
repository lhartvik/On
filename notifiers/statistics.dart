import 'package:flutter/material.dart';
import 'package:onlight/db/local_db_helper.dart';
import 'package:onlight/util/util.dart';

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

  void updateLastMedicineTaken() async {
    _lastMedicineTaken = await LocalDBHelper.instance.lastMedicineTaken();
    notifyListeners();
  }

  void updateLastLog() async {
    _lastLog = await LocalDBHelper.instance.lastLog();
    notifyListeners();
  }

  String get timeSinceLastMedicineTakenString {
    return Util.formatTidSiden(Util.timeSince(_lastMedicineTaken));
  }

  String get timeSinceLastLogString {
    return Util.formatTidSiden(Util.timeSince(_lastLog));
  }
}
