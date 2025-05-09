import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:onlight/db/local_db_helper.dart';
import 'package:onlight/model/day_log.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/logg_type.dart' show LoggType;
import 'package:onlight/util/util.dart';
import 'package:onlight/widgets/day_stats_widget.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: LocalDBHelper.instance.readAllLogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Fant ingen data'));
            } else {
              List<Logg> logs = snapshot.data!;
              Map<String, List<Logg>> byDay = groupBy(logs, (log) => Util.formatDato(log.lokalDato));
              List<DayLog> dayLogs = [];
              for (var hverDato in byDay.keys) {
                if (containsMed(byDay[hverDato])) dayLogs.add(DayLog(hverDato, byDay[hverDato]!));
              }
              return ListView(children: [for (DayLog day in dayLogs) DayStatsWidget(day)]);
            }
          },
        ),
      ),
    );
  }

  bool containsMed(List<Logg>? list) {
    if (list == null) return false;
    return list.any((log) => log.event == LoggType.medicineTaken.name);
  }
}
