import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_app/db/supabase_helper.dart';
import 'package:on_app/notifiers/statistics.dart';
import 'package:provider/provider.dart';

class CloudDbWidget extends StatefulWidget {
  const CloudDbWidget({super.key});

  @override
  State<CloudDbWidget> createState() => _CloudDbWidgetState();
}

class _CloudDbWidgetState extends State<CloudDbWidget> {
  String? _userId;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    final stats = Provider.of<Statistics>(context, listen: false);
    SupabaseHelper.instance.auth.then((auth) {
      _authSubscription = auth.onAuthStateChange.listen((data) {
        if (mounted) {
          setState(() {
            _userId = data.session?.user.email;
          });
        }
      });
      stats.updateLastCloudLog();
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
    final stats = Provider.of<Statistics>(context);
    return Card(
      child: ListTile(
        title: Text("Skydatabase"),
        leading: Icon(Icons.cloud),
        trailing: Text(_userId ?? "Ikke innlogget"),
        subtitle: Text("Sist registrert: ${stats.lastCloudLogString}"),
      ),
    );
  }
}
