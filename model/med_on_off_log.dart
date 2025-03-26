import 'package:collection/collection.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/logg_type.dart';
import 'package:onlight/util/util.dart';

class MedOnOffLog {
  final List<Logg> logs;
  final DateTime tmed;
  final DateTime? tprevmed;
  final DateTime? tnextmed;
  final LoggType? lastEventBeforeMed;

  MedOnOffLog(this.tmed, this.logs, {this.tprevmed, this.tnextmed, this.lastEventBeforeMed});

  DateTime get maxTime =>
      [
        tnextmed,
        tmed.add(Duration(hours: 8)),
        Util.endOfDay(tmed).toUtc(),
        DateTime.now().toUtc(),
      ].whereType<DateTime>().min;

  List<EventDuration> get onOffDurations {
    List<EventDuration> durations = [];

    LoggType currentEvent = lastEventBeforeMed ?? LoggType.medicineTaken;
    DateTime currentEventTime = tmed;
    for (Logg log in logs) {
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
