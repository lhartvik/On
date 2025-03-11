import 'package:collection/collection.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/logg_type.dart';

class MedOnOffLog {
  final List<Logg> logs;
  final DateTime tmed;
  final DateTime? tprevmed;
  final DateTime? tnextmed;
  final LoggType? lastEventBeforeMed;

  MedOnOffLog(this.tmed, this.logs, {this.tprevmed, this.tnextmed, this.lastEventBeforeMed});

  DateTime get maxTime =>
      tnextmed ??
      ((tmed.add(Duration(hours: 8)).isAfter(DateTime.now())) ? DateTime.now() : tmed.add(Duration(hours: 8)));

  List<EventDuration> get onOffDurations {
    List<EventDuration> durations = [];

    LoggType currentEvent = lastEventBeforeMed ?? LoggType.medicineTaken;
    DateTime currentEventTime = tmed;
    for (Logg log in logs.sorted((a, b) => a.dateTime.compareTo(b.dateTime))) {
      if (LoggType.of(log.event) != currentEvent) {
        durations.add(EventDuration(event: currentEvent, duration: log.dateTime.difference(currentEventTime)));
        currentEventTime = log.dateTime;
        currentEvent = LoggType.of(log.event);
      }
    }
    durations.add(EventDuration(event: currentEvent, duration: maxTime.difference(currentEventTime)));
    return durations;
  }
}
