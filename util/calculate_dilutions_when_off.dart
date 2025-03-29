import 'package:onlight/model/med_on_off_log.dart' show MedOnOffLog;
import 'package:onlight/util/dilution_table.dart';

Map<DateTime, double> calculateDilutionsWhenTurnedOff(List<MedOnOffLog> medOnOffLogs, List<DateTime> timesOff) {
  Map<DateTime, double> dilutionsWhenOff = {};
  for (var timeOff in timesOff) {
    for (var medOnOffLog in medOnOffLogs.where((log) => log.tmed.isBefore(timeOff))) {
      dilutionsWhenOff[timeOff] =
          dilutionsWhenOff[timeOff] ?? 0 + DilutionTable.cAfter(timeOff.difference(medOnOffLog.tmed));
    }
  }
  dilutionsWhenOff.removeWhere((key, value) => value < 0.05);

  return dilutionsWhenOff;
}
