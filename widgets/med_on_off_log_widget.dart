import 'package:flutter/material.dart';
import 'package:onlight/model/event_duration.dart';
import 'package:onlight/model/logg_type.dart';
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
                Expanded(
                  flex: event.duration.inMinutes + 1,
                  child: Container(height: 10, color: LoggType.colorOf(event.event)),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (EventDuration event in onOffDurations)
                Text('${LoggType.short(event.event)} ${event.duration.inMinutes}m'),
              if (medOnOffLog.tnextmed != null) Text(Util.onlyTime(medOnOffLog.tnextmed!.toLocal())),
            ],
          ),
        ],
      ),
    );
  }
}
