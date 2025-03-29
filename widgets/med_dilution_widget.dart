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
    int resolution = 25;

    return Row(
      children: [
        SizedBox(width: sizeOfUptake, height: height),
        for (int i = 1; i <= resolution; i++)
          Expanded(
            flex: (longestDuration.inMinutes / resolution).round(),
            child: Container(
              height: height * DilutionTable.cAfterMinutes((i * longestDuration.inMinutes / resolution).round()),
              color: Theme.of(context).colorScheme.primaryFixedDim,
            ),
          ),
      ],
    );
  }
}
