import 'package:flutter/material.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/widgets/med_on_off_log_widget.dart';

class DayStatsWidget extends StatelessWidget {
  final String day;
  final List<MedOnOffLog> logs;

  const DayStatsWidget(this.day, this.logs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(children: [Text(day), for (var log in logs) MedOnOffLogWidget(medOnOffLog: log)]),
    );
  }
}
