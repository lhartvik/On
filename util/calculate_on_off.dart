import 'package:collection/collection.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/med_on_off_log.dart';

List<Logg> getSortedMedList(List<Logg> allLogs) {
  return allLogs.where((log) => log.event == LoggType.medicineTaken.name).toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
}

List<MedOnOffLog> calculateOnOff(List<Logg> logs) {
  List<MedOnOffLog> result = [];

  List<Logg> meds = getSortedMedList(logs);

  for (Logg med in meds) {
    DateTime tmed = med.dateTime;
    DateTime? tplus = med.dateTime;
    DateTime? tminus;
    Logg? forrigeMed = meds.lastWhereOrNull((log) => log.dateTime.isBefore(med.dateTime));
    Logg? nextMed = meds.firstWhereOrNull((log) => log.dateTime.isAfter(med.dateTime));

    bool onBeforeMed = logs.any(
      (onEvent) =>
          onEvent.event == LoggType.on.name &&
          onEvent.dateTime.isBefore(med.dateTime) &&
          !(logs.any(
            (offBetweenOnAndMed) =>
                offBetweenOnAndMed.event == LoggType.off.name &&
                offBetweenOnAndMed.dateTime.isAfter(onEvent.dateTime) &&
                offBetweenOnAndMed.dateTime.isBefore(med.dateTime),
          )),
    );

    tplus =
        onBeforeMed
            ? med.dateTime
            : logs
                .firstWhereOrNull(
                  (log) =>
                      log.event == LoggType.on.name &&
                      log.dateTime.isAfter(med.dateTime) &&
                      ((nextMed == null) || log.dateTime.isBefore(nextMed.dateTime)),
                )
                ?.dateTime;
    if (tplus != null) {
      tminus =
          logs
              .firstWhereOrNull(
                (log) =>
                    log.event == LoggType.off.name &&
                    log.dateTime.isAfter(tplus!) &&
                    (nextMed == null || log.dateTime.isBefore(nextMed.dateTime)),
              )
              ?.dateTime;
      result.add(MedOnOffLog(tmed, tplus, tminus, tprevmed: forrigeMed?.dateTime, tnextmed: nextMed?.dateTime));
    }
  }

  return result;
}
