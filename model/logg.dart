import 'package:collection/collection.dart';
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

  @override
  String toString() {
    return "$timestamp $event";
  }

  @override
  operator ==(Object other) {
    return other is Logg && other.id == id && other.event == event && other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^ event.hashCode ^ timestamp.hashCode;
  }
}

enum LoggType {
  medicineTaken("Ta medisin"),
  on("On"),
  off("Off"),
  error("Error");

  final String name;
  const LoggType(this.name);

  static LoggType of(String? s) {
    return LoggType.values.firstWhereOrNull((element) => element.name == s) ?? LoggType.error;
  }
}
