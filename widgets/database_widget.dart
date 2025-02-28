import 'package:flutter/material.dart';
import 'package:on_app/db/database_helper.dart';
import 'package:on_app/model/logg.dart';
import 'package:on_app/util/util.dart';

class DatabaseWidget extends StatelessWidget {
  const DatabaseWidget({
    super.key,
    required this.databasehelper,
    required this.icon,
  });

  final DatabaseHelper databasehelper;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databasehelper.readAllLogs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          String text;
          String lastLogText;
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            text = 'Tom tabell';
            lastLogText = 'Aldri';
          } else {
            List<Logg> logs = snapshot.data!;
            logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            text = logs.length.toString();
            lastLogText = Util.format(DateTime.parse(logs.last.timestamp));
          }
          return Card(
            child: ListTile(
              title: Text(text),
              leading: icon,
              subtitle: Text("Sist registrert: $lastLogText"),
            ),
          );
        }
      },
    );
  }
}
