import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:on_app/notifiers/statistics.dart';
import 'package:on_app/widgets/cloud_db_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CloudScreen extends StatefulWidget {
  const CloudScreen({super.key});

  @override
  State<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  String? _userId;
  StreamSubscription? _authSubscription;
  RealtimeChannel? _subscription;

  @override
  void initState() {
    final stats = Provider.of<Statistics>(context, listen: false);
    LocalDBHelper.instance.lastLog().then((value) {
      stats.updateLastLog();
    });
    SupabaseHelper.instance.auth.then((auth) {
      _authSubscription = auth.onAuthStateChange.listen((data) {
        if (mounted) {
          setState(() {
            _userId = data.session?.user.email;
          });
        }
      });
    });
    _subscription = SupabaseHelper.instance.subscription((payload) {
      setState(() {
        stats.updateLastCloudLog();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription!.unsubscribe();
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<Statistics>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(_userId != null ? '$_userId innlogget' : 'Ikke innlogget'),
            Card(
              child: ListTile(
                title: Text("Lokal database"),
                leading: Icon(Icons.smartphone),
                subtitle: Text("Sist registrert: ${stats.lastLogString}"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    LocalDBHelper.instance.readAllLogs().then((locallogs) {
                      SupabaseHelper.instance.readAllLogs().then((cloudlogs) {
                        locallogs.removeWhere(
                          (x) => cloudlogs.any((y) => x.id == y.id),
                        );
                        SupabaseHelper.instance.insertAllLogs(locallogs).then((
                          x,
                        ) {
                          stats.updateLastCloudLog();
                        });
                      });
                    });
                  },
                  icon: Icon(Icons.arrow_downward_rounded),
                  label: Text('Last opp'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    SupabaseHelper.instance.readAllLogs().then((cloudlogs) {
                      LocalDBHelper.instance.readAllLogs().then((locallogs) {
                        cloudlogs.removeWhere(
                          (x) => locallogs.any((y) => x.id == y.id),
                        );
                        LocalDBHelper.instance.insertAllLogs(cloudlogs).then((
                          x,
                        ) {
                          stats.updateLastLog();
                        });
                      });
                    });
                  },
                  icon: Icon(Icons.arrow_upward_outlined),
                  label: Text('Last ned'),
                ),
              ],
            ),
            CloudDbWidget(),
          ],
        ),
      ),
    );
  }
}
