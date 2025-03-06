import 'package:flutter/material.dart';
import 'package:onlight/screens/stats_screen.dart';

class DayStats extends StatelessWidget {
  final String day;
  final List<MedOnOffLog> logs;

  const DayStats(this.day, this.logs, {super.key});

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
      child: Column(
        children: [
          Text(day),
          for (var log in logs) MedOnOffLogWidget(log: log),
        ],
      ),
    );
  }
}
