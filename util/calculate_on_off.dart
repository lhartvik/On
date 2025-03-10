import 'package:collection/collection.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/med_on_off_log.dart';

List<Logg> getSortedMedList(List<Logg> allLogs) {
  return allLogs.where((log) => log.event == LoggType.medicineTaken.name).toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
}

List<MedOnOffLog> calculateOnOff(List<Logg> logsUnsorted) {
  List<MedOnOffLog> result = [];

  List<Logg> logs = logsUnsorted.sorted((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Logg> meds = getSortedMedList(logs);

  for (Logg med in meds) {
    DateTime tmed = med.dateTime;
    Logg? forrigeMed = meds.lastWhereOrNull((log) => log.dateTime.isBefore(med.dateTime));
    Logg? nextMed = meds.firstWhereOrNull((log) => log.dateTime.isAfter(med.dateTime));

    String? lastEventBeforeMed =
        logs
            .lastWhereOrNull(
              (onOrOff) =>
                  onOrOff.dateTime.isBefore(med.dateTime) &&
                  [LoggType.on.name, LoggType.off.name].contains(onOrOff.event),
            )
            ?.event;

    result.add(
      MedOnOffLog(
        tmed,
        logs
            .where((log) => log.dateTime.isAfter(tmed) && (nextMed == null || log.dateTime.isBefore(nextMed.dateTime)))
            .toList(),
        tprevmed: forrigeMed?.dateTime,
        tnextmed: nextMed?.dateTime,
        lastEventBeforeMed: (lastEventBeforeMed != null) ? LoggType.of(lastEventBeforeMed) : null,
      ),
    );
  }

  return result;
}
