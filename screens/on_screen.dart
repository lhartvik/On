import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onlight/db/sqflite_helper.dart';
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final stats = Provider.of<Statistics>(context, listen: false);
    stats.updateLastMedicineTaken();
    stats.updateLastLog();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<Statistics>(context);
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
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
                  InkWell(
                    onLongPress: () async {
                      LocalDBHelper.instance.clearAll();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Slettet alt')))
                          .closed
                          .then((reason) {
                            stats.updateLastMedicineTaken();
                            stats.updateLastLog();
                            setState(() {});
                          });
                    },
                    child: Text('Slett alt'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
