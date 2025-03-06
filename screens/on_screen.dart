import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onlight/notifiers/statistics.dart';
import 'package:onlight/widgets/loggeknapp.dart';
import 'package:provider/provider.dart';

class OnScreen extends StatefulWidget {
  const OnScreen({super.key});

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Statistics stats = Provider.of<Statistics>(context, listen: false);
    stats.updateLastMedicineTaken();
    stats.updateLastLog();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build!");
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return VerticalAligned();
          } else {
            return HorizontalAligned();
          }
        },
      ),
    );
  }
}

class VerticalAligned extends StatelessWidget {
  const VerticalAligned({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<Statistics>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Loggeknapp(tittel: 'Ta medisin'),
                Text(stats.lastMedicineTakenString),
                Text(stats.timeSinceLastMedicineTakenString),
                Loggeknapp(tittel: 'On'),
                Loggeknapp(tittel: 'Off'),
                Text(stats.timeSinceLastLogString),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalAligned extends StatelessWidget {
  const HorizontalAligned({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<Statistics>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            height: 300,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 20,
                    children: [
                      Loggeknapp(tittel: 'Ta medisin'),
                      Text(stats.lastMedicineTakenString),
                      Text(stats.timeSinceLastMedicineTakenString),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 20,
                    children: [
                      Loggeknapp(tittel: 'On'),
                      Loggeknapp(tittel: 'Off'),
                      Text(stats.timeSinceLastLogString),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
