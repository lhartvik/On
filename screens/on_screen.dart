import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_app/components/loggeknapp.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../util/knapperegler.dart';

class OnScreen extends StatefulWidget {
  const OnScreen({super.key});

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  DateTime? _lastMedicineTaken;
  late Timer _timer;
  String _timeAgo = '';

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  updateLastMedicineTaken() async {
    try {
      final value = await LocalDBHelper.instance.lastMedicineTaken();
      if (value != null) {
        setState(() {
          value;
          _lastMedicineTaken = value;
          _timeAgo = Util.timeAgo(value);
        });
      } else {
        setState(() {
          _lastMedicineTaken = null;
          _timeAgo = 'Aldri';
        });
      }
    } catch (e) {
      print('Error fetching last medicine taken: $e');
    }
  }

  updateTimeAgo() {
    setState(() {
      _timeAgo = Util.timeAgo(_lastMedicineTaken);
    });
  }

  @override
  void initState() {
    super.initState();
    updateLastMedicineTaken();

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateTimeAgo();
    });
  }

  void callback(PostgresChangePayload payload) {
    String event = payload.newRecord['event'];
    if (event == 'Ta medisin') {
      setState(() {
        _lastMedicineTaken =
            DateTime.parse(payload.newRecord['timestamp']).toUtc();
        _timeAgo = Util.timeAgo(_lastMedicineTaken);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Sist tatt: ${Util.format(_lastMedicineTaken)} (UTC)'),
                  Text(
                    _timeAgo,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Loggeknapp(tittel: 'On'),
                  Loggeknapp(tittel: 'Off'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
