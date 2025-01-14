import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_app/components/loggeknapp.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'util/knapperegler.dart';

class OnScreen extends StatefulWidget {
  const OnScreen({super.key});

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  DateTime? _lastMedicineTaken;
  bool _isOn = false;
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

  updateStatus() async {
    try {
      final isOn = await LocalDBHelper.instance.lastStatus();
      setState(() {
        _isOn = isOn;
      });
    } catch (e) {
      print('Error fetching status: $e');
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
    updateStatus();

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
    if (['On', 'Off'].contains(event)) {
      setState(() {
        _isOn = event == 'On';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: Column(
          spacing: 5,
          children: [
            Loggeknapp(
                tittel: 'Ta medisin',
                theme: theme,
                disabled: false,
                action: () {
                  setState(() {
                    _lastMedicineTaken = DateTime.now().toUtc();
                  });
                  updateTimeAgo();
                }),
            Text('Sist tatt: ${Util.format(_lastMedicineTaken)} (UTC)'),
            Text(_timeAgo),
            Loggeknapp(
                tittel: 'On',
                theme: theme,
                disabled: _isOn,
                action: () {
                  setState(() {
                    _isOn = true;
                  });
                }),
            if (_isOn) Text("Du er on!") else Text("Du er off..."),
            Loggeknapp(
                tittel: 'Off',
                theme: theme,
                disabled: !_isOn,
                action: () {
                  setState(() {
                    _isOn = false;
                  });
                }),
            ElevatedButton(
                onPressed: () {
                  LocalDBHelper.instance.clearAll();
                  updateLastMedicineTaken();
                  updateTimeAgo();
                },
                child: Text('Slett alt')),
          ],
        ),
      ),
    );
  }
}
