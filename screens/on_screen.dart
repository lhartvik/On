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
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: OrientationBuilder(
        builder: (context, orientation) =>
          (orientation == Orientation.portrait) ? VerticallyAligned() : HorizontallyAligned();
      ),
    );
  }
}

class VerticallyAligned extends StatelessWidget {
  const VerticallyAligned({super.key});

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
                Loggeknapp(tittel: 'Dyskinesi'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontallyAligned extends StatelessWidget {
  const HorizontallyAligned({super.key});

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
                      // TextButton(
                      //   onPressed: () async {
                      //     readCsvFile().then((value) {
                      //       LocalDBHelper.instance.insertAllLogs(value);
                      //     });
                      //   },
                      //   child: Text("importer"),
                      // ),
                      // TextButton(onPressed: () => LocalDBHelper.instance.deleteAllLogs(), child: Text("Slett alt")),
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
                      Loggeknapp(tittel: 'Dyskinesi'),
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
