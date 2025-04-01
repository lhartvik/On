import 'package:flutter/material.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/logg_type.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/util/util.dart';

class MedOnOffLogWidget extends StatelessWidget {
  final MedOnOffLog medOnOffLog;
  final Duration longestDuration;

  const MedOnOffLogWidget({super.key, required this.medOnOffLog, required this.longestDuration});

  @override
  Widget build(BuildContext context) {
    List<EventDuration> onOffDurations = medOnOffLog.onOffDurations;
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
          Row(
            children: [
              for (EventDuration event in onOffDurations)
                Expanded(
                  flex: percentageToTakeUp(event.duration, longestDuration),
                  child: Container(height: 10, color: LoggType.colorOf(event.event)),
                ),
              Expanded(flex: 100 - percentageToTakeUp(medOnOffLog.duration, longestDuration), child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  int percentageToTakeUp(Duration event, Duration longest) {
    if (longest.inMinutes == 0) {
      return 100;
    }
    return ((event.inMinutes / longest.inMinutes) * 100).round();
  }
}
