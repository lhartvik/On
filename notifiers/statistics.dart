import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:on_app/util/util.dart';

class Statistics extends ChangeNotifier {
  DateTime? _lastMedicineTaken;
  DateTime? _lastLog;
  DateTime? _lastCloudLog;

  DateTime? get lastMedicineTaken => _lastMedicineTaken;
  DateTime? get lastLog => _lastLog;
  DateTime? get lastCloudLog => _lastCloudLog;

  String get lastMedicineTakenString {
    return Util.format(_lastMedicineTaken?.toLocal());
  }

  String get lastLogString {
    return Util.format(_lastLog?.toLocal());
  }

  String get lastCloudLogString {
    return Util.format(_lastCloudLog?.toLocal());
  }

  void updateLastMedicineTaken() async {
    _lastMedicineTaken = await LocalDBHelper.instance.lastMedicineTaken();
    notifyListeners();
  }

  void updateLastLog() async {
    _lastLog = await LocalDBHelper.instance.lastLog();
    notifyListeners();
  }

  void updateLastCloudLog() async {
    _lastCloudLog = await SupabaseHelper.instance.lastLog();
    notifyListeners();
  }

  String get timeSinceLastMedicineTakenString {
    return Util.formatTidSiden(Util.timeSince(_lastMedicineTaken));
  }

  String get timeSinceLastLogString {
    return Util.formatTidSiden(Util.timeSince(_lastLog));
  }

  String get timeSinceLastCloudLogString {
    return Util.formatTidSiden(Util.timeSince(_lastCloudLog));
  }
}
