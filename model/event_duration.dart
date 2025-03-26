import 'package:onlight/model/logg_type.dart';

class EventDuration {
  final LoggType event;
  Duration duration;

  EventDuration({required this.event, required this.duration});

  set setDuration(Duration duration) {
    duration = duration;
  }

  @override
  String toString() {
    return "${event.name} $duration m";
  }

  @override
  bool operator ==(Object other) {
    if (other is EventDuration) {
      return event == other.event && duration == other.duration;
    }
    return false;
  }

  @override
  int get hashCode => event.hashCode ^ duration.hashCode;
}
