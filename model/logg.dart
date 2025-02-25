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
}
