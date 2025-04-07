import 'package:flutter/material.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/util/util.dart';

class MedOnOffLogWidget extends StatelessWidget {
  final MedOnOffLog medOnOffLog;
  final Duration longestDuration;

  const MedOnOffLogWidget({super.key, required this.medOnOffLog, required this.longestDuration});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (longestDuration.inMinutes < 1 || medOnOffLog.duration > longestDuration) {
      return const SizedBox(height: 30);
    }

    return SizedBox(
      width: size.width - 20,
      height: 30,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text(Util.onlyTime(medOnOffLog.tmed.toLocal()))),
              Text(Util.durationString(medOnOffLog.duration)),
            ],
          ),
          Stack(
            children:
                [
                  medOnOffLog.onOffDurations,
                  medOnOffLog.dyskinesiaDurations,
                ].map((events) => _buildEventBar(events, medOnOffLog.duration)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBar(List<EventDuration> events, Duration total) {
    return Row(
      children: [
        for (EventDuration duration in events)
          Expanded(
            flex: promilleToTakeUp(duration.duration, longestDuration) + 3,
            child: Container(height: 10, color: duration.event.color),
          ),
        if (total < longestDuration)
          Expanded(
            flex: 1000 - promilleToTakeUp(total, longestDuration),
            child: Container(height: 10, color: Colors.transparent),
          ),
      ],
    );
  }

  int promilleToTakeUp(Duration event, Duration longest) => ((event.inMinutes / longest.inMinutes) * 1000).round();
}
