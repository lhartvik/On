import 'package:flutter/material.dart';
import 'package:onlight/model/med_on_off_log.dart';
import 'package:onlight/util/util.dart';

class MedOnOffLogWidget extends StatelessWidget {
  final MedOnOffLog log;

  const MedOnOffLogWidget({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    int rest = log.timeUntilOff.inMinutes - log.timeOn.inMinutes;
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
              if (rest > 0) Text('${rest}m'),
            ],
          ),
        ],
      ),
    );
  }
}
