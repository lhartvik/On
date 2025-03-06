import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:onlight/db/sqflite_helper.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/util/util.dart';
import 'package:onlight/widgets/day_stats.dart';

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
              Map<String, List<Logg>> byDay = groupBy(
                logs,
                (log) => Util.formatDato(log.dato),
              );
              List<DayLog> dayLogs = [];
              for (var key in byDay.keys) {
                dayLogs.add(DayLog(key, byDay[key]!));
              }
              print(dayLogs);
              return ListView(
                children: [
                  for (DayLog day in dayLogs.where(
                    (day) => day.medOnOffLogs.isNotEmpty,
                  ))
                    DayStats(day.day, day.medOnOffLogs),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class DayLog {
  final String day;
  final List<Logg> logs;

  DayLog(this.day, this.logs);

  List<MedOnOffLog> get medOnOffLogs {
    List<MedOnOffLog> result = [];
    logs
        .sortedBy((log) => log.dateTime)
        .where((log) => log.event == LoggType.medicineTaken.name)
        .forEach((Logg med) {
          DateTime tmed = med.dateTime;
          DateTime? tplus;
          DateTime? tminus;
          Logg? forrigeMed =
              logs
                  .where(
                    (log) =>
                        log.dateTime.isBefore(med.dateTime) &&
                        log.event == LoggType.medicineTaken.name,
                  )
                  .sortedBy((log) => log.dateTime)
                  .reversed
                  .lastOrNull;
          Logg? nextMed =
              logs
                  .where(
                    (log) =>
                        log.dateTime.isAfter(med.dateTime) &&
                        log.event == LoggType.medicineTaken.name,
                  )
                  .sortedBy((log) => log.dateTime)
                  .reversed
                  .firstOrNull;

          logs
              .where(
                (log) =>
                    log.dateTime.isAfter(tmed) && log.event == LoggType.on.name,
              )
              .forEach((Logg log) {
                tplus = log.dateTime;
                if (log.event == LoggType.on.name) {
                  logs.where((log) => log.dateTime.isAfter(tplus!)).forEach((
                    Logg log,
                  ) {
                    if (log.event == LoggType.off.name && tminus == null) {
                      tminus = log.dateTime;
                    }
                  });
                }
              });
          if (tplus != null) {
            result.add(
              MedOnOffLog(
                tmed,
                tplus!,
                tminus,
                tprevmed: forrigeMed?.dateTime,
                tnextmed: nextMed?.dateTime,
              ),
            );
          }
        });
    return result;
  }

  @override
  String toString() {
    return "$day $medOnOffLogs";
  }
}

class MedOnOffLog {
  DateTime tmed;
  DateTime tplus;
  DateTime? tminus;
  DateTime? tprevmed;
  DateTime? tnextmed;

  MedOnOffLog(
    this.tmed,
    this.tplus,
    this.tminus, {
    this.tprevmed,
    this.tnextmed,
  });

  Duration get timeUntilOn {
    return tplus.difference(tmed);
  }

  Duration get timeUntilOff {
    return tminus?.difference(tmed) ?? Duration.zero;
  }

  Duration get timeOn {
    return tminus?.difference(tplus) ?? Duration.zero;
  }

  Duration get timeUntilNextMed {
    return tnextmed?.difference(tmed) ?? Duration.zero;
  }

  @override
  String toString() {
    String tmedString =
        ((tprevmed != null) ? Util.onlyTime(tprevmed!) : "(no prevmed)");
    tmedString = "$tmedString|${Util.onlyTime(tmed)}";
    tmedString = "$tmedString|${Util.onlyTime(tplus)}";
    tmedString =
        "$tmedString|${(tminus != null) ? Util.onlyTime(tminus!) : "(no tminus)"}";
    tmedString =
        "$tmedString|${(tnextmed != null) ? Util.onlyTime(tnextmed!) : "(no nextmed)"}";
    return tmedString;
  }
}

class MedOnOffLogWidget extends StatelessWidget {
  final MedOnOffLog log;

  const MedOnOffLogWidget({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 50,
      child: Column(
        children: [
          Text(Util.onlyTime(log.tmed)),
          Row(
            children: [
              Expanded(
                flex: log.timeUntilOn.inMinutes,
                child: Container(height: 10, color: Colors.black),
              ),
              Expanded(
                flex: log.timeOn.inMinutes,
                child: Container(height: 10, color: Colors.green),
              ),
              Expanded(
                flex: log.timeUntilOff.inMinutes - log.timeOn.inMinutes,
                child: Container(height: 10, color: Colors.red),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${log.timeUntilOn.inMinutes}m'),
              Text('${log.timeOn.inMinutes}m'),
              Text('${(log.timeUntilOff.inMinutes - log.timeOn.inMinutes)}m'),
            ],
          ),
        ],
      ),
    );
  }
}
