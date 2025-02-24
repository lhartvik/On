import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:on_app/model/logg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/database_helper.dart';
import '../util/knapperegler.dart';

class CloudScreen extends StatefulWidget {
  const CloudScreen({super.key});

  @override
  State<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  String? _userId;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    SupabaseHelper.instance.auth.then((auth) {
      _authSubscription = auth.onAuthStateChange.listen((data) {
        if (mounted) {
          setState(() {
            _userId = data.session?.user.email;
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(_userId != null ? '$_userId innlogget' : 'Ikke innlogget'),
            DatabaseWidget(
                databasehelper: LocalDBHelper.instance,
                icon: Icon(Icons.smartphone)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      LocalDBHelper.instance.readAllLogs().then((logs) {
                        SupabaseHelper.instance.insertAllLogs(logs);
                        setState(() {});
                      });
                    },
                    icon: Icon(Icons.arrow_downward_rounded),
                    label: Text('Last opp')),
                ElevatedButton.icon(
                    onPressed: () {
                      SupabaseHelper.instance.readAllLogs().then((logs) {
                        LocalDBHelper.instance.insertAllLogs(logs);
                        setState(() {});
                      });
                    },
                    icon: Icon(Icons.arrow_upward_outlined),
                    label: Text('Last ned')),
              ],
            ),
            DatabaseWidget(
                databasehelper: SupabaseHelper.instance,
                icon: Icon(Icons.cloud))
          ],
        ),
      ),
    );
  }
}

class DatabaseWidget extends StatefulWidget {
  const DatabaseWidget({
    super.key,
    required this.databasehelper,
    required this.icon,
  });

  final DatabaseHelper databasehelper;
  final Icon icon;

  @override
  State<DatabaseWidget> createState() => _DatabaseWidgetState();
}

class _DatabaseWidgetState extends State<DatabaseWidget> {
  DateTime? _lastMedicineTaken;
  String _timeAgo = 'Aldri';
  Timer? _timer;

  updateLastMedicineTaken() async {
    try {
      await widget.databasehelper.lastMedicineTaken().then((value) {
        setState(() {
          _lastMedicineTaken = value;
          _timeAgo = Util.timeAgo(value);
        });
      });
    } catch (e) {
      print('Error fetching last medicine taken: $e');
    }
  }

  updateTimeAgo() {
    setState(() {
      _timeAgo = Util.timeAgo(_lastMedicineTaken);
    });
  }

  RealtimeChannel? _subscription;

  @override
  void initState() {
    updateLastMedicineTaken().then((_) => updateTimeAgo());
    if (widget.databasehelper is SupabaseHelper) {
      _subscription = SupabaseHelper.instance.subscription((payload) {
        String event = payload.newRecord['event'];
        if (event == 'Ta medisin') {
          setState(() {
            _lastMedicineTaken =
                DateTime.parse(payload.newRecord['timestamp']).toUtc();
            _timeAgo = Util.timeAgo(_lastMedicineTaken);
          });
        }
      });
    }
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (widget.databasehelper is LocalDBHelper) {
        updateLastMedicineTaken();
      } else {
        updateTimeAgo();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription!.unsubscribe();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.databasehelper.readAllLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            String text;
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              text = 'Tom tabell';
            } else {
              List<Logg> logs = snapshot.data!;
              logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
              text = logs.length.toString();
            }
            return Card(
                child: ListTile(
              title: Text(text),
              leading: widget.icon,
              subtitle: Text(_timeAgo),
            ));
          }
        });
  }
}
