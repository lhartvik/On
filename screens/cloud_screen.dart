import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:on_app/notifiers/statistics.dart';
import 'package:on_app/notifiers/statistics_cloud.dart';
import 'package:on_app/widgets/database_widget.dart';
import 'package:provider/provider.dart';

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
    final stats = Provider.of<Statistics>(context, listen: false);
    final cloudstats = Provider.of<StatisticsCloud>(context, listen: false);
    LocalDBHelper.instance.lastLog().then((value) {
      stats.updateLastLog(value);
    });
    SupabaseHelper.instance.auth.then((auth) {
      _authSubscription = auth.onAuthStateChange.listen((data) {
        if (mounted) {
          SupabaseHelper.instance.lastLog().then((value) {
            cloudstats.updateLastLog(value);
          });
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
              icon: Icon(Icons.smartphone),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    LocalDBHelper.instance.readAllLogs().then((locallogs) {
                      SupabaseHelper.instance.readAllLogs().then((cloudlogs) {
                        locallogs.removeWhere(cloudlogs.contains);
                        SupabaseHelper.instance.insertAllLogs(locallogs);
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
                        LocalDBHelper.instance.insertAllLogs(cloudlogs);
                      });
                    });
                  },
                  icon: Icon(Icons.arrow_upward_outlined),
                  label: Text('Last ned'),
                ),
              ],
            ),
            DatabaseWidget(
              databasehelper: SupabaseHelper.instance,
              icon: Icon(Icons.cloud),
            ),
          ],
        ),
      ),
    );
  }
}
