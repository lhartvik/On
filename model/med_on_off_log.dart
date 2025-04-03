import 'package:collection/collection.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/logg_type.dart';
import 'package:onlight/util/util.dart';

class MedOnOffLog {
  final List<Logg> logs;
  final DateTime tmed;
  final DateTime? tnextmed;
  final LoggType? lastEventBeforeMed;

  MedOnOffLog(this.tmed, this.logs, {this.tnextmed, this.lastEventBeforeMed});

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
    for (Logg log in logs
        .where((logg) => logg.dateTime.isBefore(maxTime))
        .where((logg) => [LoggType.on.name, LoggType.off.name].contains(logg.event))) {
      if (LoggType.of(log.event) != currentEvent) {
        durations.add(EventDuration(event: currentEvent, duration: log.dateTime.difference(currentEventTime)));
        currentEventTime = log.dateTime;
        currentEvent = LoggType.of(log.event);
      }
    }
    durations.add(EventDuration(event: currentEvent, duration: maxTime.difference(currentEventTime)));
    return durations;
  }

  List<EventDuration> get dyskinesiaDurations {
    List<EventDuration> durations = [];
    DateTime currentEventTime = tmed;
    for (Logg log in logs
        .where((logg) => logg.dateTime.isBefore(maxTime))
        .where((log) => log.event == LoggType.dyskinesia.name)) {
      durations.add(EventDuration(event: LoggType.none, duration: log.dateTime.difference(currentEventTime)));
      durations.add(EventDuration(event: LoggType.dyskinesia, duration: Duration.zero));
      currentEventTime = log.dateTime;
    }
    durations.add(EventDuration(event: LoggType.none, duration: maxTime.difference(currentEventTime)));
    return durations;
  }

  Duration get duration => maxTime.difference(tmed);

  Duration? get timeUntilOn {
    return logs
        .where((event) => LoggType.of(event.event) == LoggType.on)
        .map((event) => event.dateTime)
        .firstOrNull
        ?.difference(tmed);
  }

  Duration? get timeUntilOff {
    var on = timeUntilOn;
    if (on == null) return null;
    return logs
        .where((event) => event.dateTime.isAfter(tmed.add(on)) && LoggType.of(event.event) == LoggType.off)
        .map((event) => event.dateTime)
        .firstOrNull
        ?.difference(tmed);
  }
}
