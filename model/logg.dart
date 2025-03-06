import 'package:onlight/model/simple_date.dart';
import 'package:uuid/uuid.dart';

class Logg {
  late String id;
  final String event;
  final String timestamp;

  Logg({id, required this.event, required this.timestamp}) {
    this.id = id ?? Uuid().v4();
  }

  factory Logg.fromJsonDatabase(Map<String, dynamic> jsonObject) {
    return Logg(
      id: jsonObject['id'] as String,
      event: jsonObject['event'] as String,
      timestamp: jsonObject['timestamp'] as String,
    );
  }

  Map<String, Object?> toJsonDatabase() {
    return {'id': id, 'event': event, 'timestamp': timestamp};
  }

  DateTime get dateTime {
    return DateTime.parse(timestamp);
  }

  DateTime get localDateTime {
    return DateTime.parse(timestamp).toLocal();
  }

  SimpleDate get dato {
    return SimpleDate.fromDateTime(dateTime);
  }
}

enum LoggType {
  medicineTaken("Ta medisin"),
  on("On"),
  off("Off");

  final String name;
  const LoggType(this.name);
}
