import 'package:flutter/material.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/util/util.dart';

class MedOnOffLogWidget extends StatelessWidget {
  final MedOnOffLog medOnOffLog;

  const MedOnOffLogWidget({super.key, required this.medOnOffLog});

  @override
  Widget build(BuildContext context) {
    List<EventDuration> onOffDurations = medOnOffLog.onOffDurations;
    return SizedBox(
      width: 350,
      height: 70,
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text(Util.onlyTime(medOnOffLog.tmed.toLocal()))),
          Row(
            children: [
              for (EventDuration event in onOffDurations)
                Expanded(flex: event.duration.inMinutes + 1, child: Container(height: 10, color: colorOf(event.event))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (EventDuration event in onOffDurations) Text('${short(event.event)} ${event.duration.inMinutes}m'),
              if (medOnOffLog.tnextmed != null)
                Align(alignment: Alignment.centerRight, child: Text(Util.onlyTime(medOnOffLog.tnextmed!.toLocal()))),
            ],
          ),
        ],
      ),
    );
  }
}

String short(LoggType event) {
  switch (event) {
    case LoggType.medicineTaken:
      return 'Opptak';
    case LoggType.on:
      return 'On';
    case LoggType.off:
      return 'Off';
    default:
      return '?';
  }
}

Color colorOf(LoggType event) {
  switch (event) {
    case LoggType.medicineTaken:
      return Colors.black;
    case LoggType.on:
      return Colors.green;
    case LoggType.off:
      return Colors.red;
    default:
      return Colors.grey;
  }
}
