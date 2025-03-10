import 'package:onlight/model/logg.dart';

class EventDuration {
  final LoggType event;
  Duration duration;

  EventDuration({required this.event, required this.duration});

  set setDuration(Duration duration) {
    duration = duration;
  }
}
