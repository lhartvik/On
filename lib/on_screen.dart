import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_app/components/loggeknapp.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'db/database_helper.dart';
import 'util/knapperegler.dart';

class OnScreen extends StatefulWidget {
  const OnScreen({super.key});

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  String? _userId;
  DateTime? _lastMedicineTaken;
  bool _isOn = false;
  late Timer _timer;
  String _timeAgo = '';

  Mode mode = Mode.Local;

  dynamic _subscription;

  @override
  void dispose() {
    _timer.cancel();
    if (_subscription != null) _subscription.unsubscribe();
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
    final value = await LocalDBHelper.instance.lastStatus();
    setState(() {
      _isOn = value;
    });
  }

  updateTimeAgo() {
    setState(() {
      _timeAgo = Util.timeAgo(_lastMedicineTaken);
    });
  }

  @override
  void initState() {
    super.initState();
    if (mode == Mode.Supabase) {
      SupabaseHelper.instance.auth
          .then((auth) => auth.onAuthStateChange.listen((data) {
                setState(() {
                  _userId = data.session?.user.id;
                });
              }));
      _subscription = Supabase.instance.client
          .channel('events')
          .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'events',
              callback: (PostgresChangePayload payload) {
                print(payload);
                String event = payload.newRecord['event'];
                if (event == 'Ta medisin') {
                  setState(() {
                    _lastMedicineTaken =
                        DateTime.parse(payload.newRecord['timestamp']);
                    _timeAgo = Util.timeAgo(_lastMedicineTaken);
                  });
                }
                if (['On', 'Off'].contains(event)) {
                  setState(() {
                    _isOn = event == 'On';
                  });
                }
              })
          .subscribe();
    }
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateTimeAgo();
      if (mode == Mode.Local) {
        updateLastMedicineTaken();
        updateStatus();
      }
    });
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
            Text(_userId != null ? 'Innlogget' : 'Ikke innlogget'),
            Loggeknapp(
                tittel: 'Ta medisin',
                theme: theme,
                disabled: false,
                action: () {
                  setState(() {
                    _lastMedicineTaken = DateTime.now();
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
