import 'package:flutter/material.dart';
import 'package:onlight/util/dilution_table.dart';

class MedDilutionWidget extends StatelessWidget {
  const MedDilutionWidget({
    super.key,
    required this.longestDuration,
    required this.height,
    required this.minutesUntilOn,
  });

  final Duration longestDuration;
  final double height;
  final double minutesUntilOn;

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width - 20;
    double fractionUptake = minutesUntilOn / longestDuration.inMinutes;
    double sizeOfUptake = fullWidth * fractionUptake;

    return Row(
      children: [
        for (int i = 1; i < 10; i++)
          SizedBox(width: sizeOfUptake / 10, height: height / 10 * i, child: Container(color: Colors.blue[100]!)),
        for (int i = 1; i <= 200; i++)
          Expanded(
            flex: (longestDuration.inMinutes / 200).round(),
            child: Container(
              height: height * DilutionTable.cAfterMinutes((i * longestDuration.inMinutes / height).round()),
              color: Colors.blue[100]!,
            ),
          ),
      ],
    );
  }
}
