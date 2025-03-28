import 'package:onlight/model/logg.dart';

class DayLog {
  final String dateString;
  final List<Logg> logs;

  DayLog(this.dateString, this.logs);

  @override
  String toString() {
    return "$dateString ${logs.length}";
  }
}
