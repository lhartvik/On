import 'package:onlight/model/logg.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/util/calculate_on_off.dart';

class DayLog {
  final String day;
  final List<Logg> logs;

  DayLog(this.day, this.logs);

  List<MedOnOffLog> get medOnOffLogs {
    return calculateOnOff(logs);
  }

  @override
  String toString() {
    return "$day ${medOnOffLogs.length}";
  }
}
