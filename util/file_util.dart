import 'package:flutter/services.dart' show rootBundle;
import 'package:onlight/model/logg.dart';

Future<List<Logg>> readCsvFile() async {
  final csvString = await rootBundle.loadString('assets/events_rows.csv');
  final lines = csvString.split('\n');

  List<Logg> logs = [];
  for (var line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final values = line.split(',');

    logs.add(Logg(id: values[3].trim(), event: values[1].trim(), timestamp: values[2].trim()));
  }
  return logs;
}
