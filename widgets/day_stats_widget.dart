import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:onlight/model/day_log.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/util/calculate_dilutions_when_off.dart' show calculateDilutionsWhenTurnedOff;
import 'package:onlight/util/calculate_on_off.dart' show calculateOnOff;
import 'package:onlight/widgets/med_dilution_widget.dart';
import 'package:onlight/widgets/med_on_off_log_widget.dart';

class DayStatsWidget extends StatelessWidget {
  final DayLog day;
  final List<MedOnOffLog> medOnOffLogs;
  DayStatsWidget(this.day, {super.key}) : medOnOffLogs = calculateOnOff(day.logs);

  @override
  Widget build(BuildContext context) {
    Duration longestDuration = medOnOffLogs.map((log) => log.duration).sorted().last;

    var timesUntilOn = medOnOffLogs.map((l) => l.timeUntilOn).where((t) => t != null).map((t) => t!.inMinutes).toList();
    var timesUntilOff =
        medOnOffLogs.map((l) => l.timeUntilOff).where((t) => t != null).map((t) => t!.inMinutes).toList();
    var timesOff = medOnOffLogs.where((t) => t.timeUntilOff != null).map((m) => m.tmed.add(m.timeUntilOff!)).toList();
    Map<DateTime, double> dilutionsWhenOff = calculateDilutionsWhenTurnedOff(medOnOffLogs, timesOff);

    var averageTimeUntilOn = timesUntilOn.isNotEmpty ? timesUntilOn.average.round() : 0;
    var averageDilutionWhenTurnedOffPercentage =
        dilutionsWhenOff.isNotEmpty ? (dilutionsWhenOff.values.average * 100).round() : 0.0;
    var averageTimeUntilOff = timesUntilOff.isNotEmpty ? timesUntilOff.average.round() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (timesUntilOn.isNotEmpty)
            MedDilutionWidget(
              longestDuration: longestDuration,
              height: 30 * medOnOffLogs.length.toDouble(),
              minutesUntilOn: timesUntilOn.average,
            ),
          Column(
            children: [
              Text(day.dateString),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (timesUntilOn.isNotEmpty) Text("Tid til on: ${averageTimeUntilOn}m "),
                  if (timesOff.isNotEmpty) Text("Tid til off: ${averageTimeUntilOff}m "),
                  if (dilutionsWhenOff.isNotEmpty) Text("c_off: $averageDilutionWhenTurnedOffPercentage%"),
                ],
              ),
              for (var medOnOffLog in medOnOffLogs)
                MedOnOffLogWidget(medOnOffLog: medOnOffLog, longestDuration: longestDuration),
            ],
          ),
        ],
      ),
    );
  }
}
