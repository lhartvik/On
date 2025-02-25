import 'package:flutter/material.dart';

class Statistics extends ChangeNotifier {
  DateTime? _lastMedicineTaken;

  DateTime? get lastMedicineTaken => _lastMedicineTaken;

  String get lastMedicineTakenString {
    if (_lastMedicineTaken == null) {
      return 'Ikke registrert';
    }
    var tid = TimeOfDay.fromDateTime(_lastMedicineTaken!.toLocal());
    String formattedTime =
        '${tid.hour.toString().padLeft(2, '0')}:${tid.minute.toString().padLeft(2, '0')}';

    if (_lastMedicineTaken!.toLocal().day == DateTime.now().toLocal().day) {
      return 'Sist i dag $formattedTime';
    } else if (_lastMedicineTaken!.toLocal().day ==
        DateTime.now().toLocal().day - 1) {
      return 'Sist i går $formattedTime';
    }
    return 'Sist for ${DateTime.now().toLocal().day - _lastMedicineTaken!.toLocal().day} dager siden';
  }

  void updateLastMedicineTaken(DateTime? value) {
    _lastMedicineTaken = value;
    notifyListeners();
  }

  Duration get timeSinceLastMedicineTaken {
    if (_lastMedicineTaken == null) {
      return Duration.zero;
    }
    return DateTime.now().difference(_lastMedicineTaken!);
  }

  String get timeSinceLastMedicineTakenString {
    final time = timeSinceLastMedicineTaken;
    if (time.inDays > 0) {
      return '${time.inDays}d ${time.inHours % 24}t ${time.inMinutes % 60}m siden';
    } else if (time.inHours > 0) {
      return '${time.inHours}t ${time.inMinutes % 60}m siden';
    } else if (time.inMinutes > 0) {
      return '${time.inMinutes}m siden';
    } else {
      return 'Mindre enn ett minutt siden';
    }
  }
}
