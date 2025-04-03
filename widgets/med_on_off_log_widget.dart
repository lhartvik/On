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
          Stack(children: [medOnOffLog.onOffDurations, medOnOffLog.dyskinesiaDurations].map(_buildEventBar).toList()),
        ],
      ),
    );
  }

  Widget _buildEventBar(List<EventDuration> events) {
    return Row(
      children: [
        for (EventDuration duration in events)
          Expanded(
            flex: promilleToTakeUp(duration.duration, longestDuration) + 3,
            child: Container(height: 10, color: duration.event.color),
          ),
      ],
    );
  }

  int promilleToTakeUp(Duration event, Duration longest) {
    if (longest.inMinutes == 0) {
      return 1000;
    }
    return ((event.inMinutes / longest.inMinutes) * 1000).round();
  }
}
