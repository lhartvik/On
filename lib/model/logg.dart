class Logg {
  final String event;
  final String timestamp;

  Logg({required this.event, required this.timestamp});

  factory Logg.fromJsonDatabase(Map<String, dynamic> jsonObject) {
    return Logg(
        event: jsonObject['event'] as String,
        timestamp: jsonObject['timestamp'] as String);
  }

  Map<String, Object?> toJsonDatabase() {
    return {
      'event': event,
      'timestamp': timestamp,
    };
  }
}
