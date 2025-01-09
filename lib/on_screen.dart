import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_app/components/loggeknapp.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  updateLastMedicineTaken() async {
    SupabaseHelper.instance.lastMedicineTaken().then(
          (value) => setState(() {
            _lastMedicineTaken = value;
          }),
        );
  }

  updateStatus() async {
    SupabaseHelper.instance.lastStatus().then(
          (value) => setState(() {
            _isOn = value;
          }),
        );
  }

  @override
  void initState() {
    super.initState();
    SupabaseHelper.instance.auth
        .then((auth) => auth.onAuthStateChange.listen((data) {
              setState(() {
                _userId = data.session?.user.id;
              });
            }));
    updateLastMedicineTaken();
    Supabase.instance.client
        .channel('events')
        .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'events',
            callback: (payload) {
              updateLastMedicineTaken();
            })
        .subscribe();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateLastMedicineTaken();
      updateStatus();
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Aldri';
    }
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} dager siden';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} timer og ${difference.inMinutes.remainder(60).abs()} minutter siden';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutter siden';
    } else {
      return 'Nettopp';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String sist = _lastMedicineTaken == null
        ? 'Aldri'
        : _formatDateTime(_lastMedicineTaken!);
    String tidSiden = _timeAgo(_lastMedicineTaken);

    bool halvtimeSiden = _lastMedicineTaken != null &&
        DateTime.now().difference(_lastMedicineTaken!).inMinutes > 30;

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
                }),
            Text('Sist tatt: $sist'),
            Text(tidSiden),
            Loggeknapp(
                tittel: 'On',
                theme: theme,
                disabled: !halvtimeSiden || _isOn,
                action: () {
                  _isOn = true;
                }),
            if (_isOn) Text("Du er on!") else Text("Du er off..."),
            Loggeknapp(
                tittel: 'Off',
                theme: theme,
                disabled: !halvtimeSiden || !_isOn,
                action: () {
                  _isOn = false;
                }),
          ],
        ),
      ),
    );
  }
}
