import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/model/logg.dart';
import 'package:on_app/util/util.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: LocalDBHelper.instance.readAllLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Logg> logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                Logg logg = logs[index];
                DateTime tid = DateTime.parse(logg.timestamp);
                return Card(
                  child: ListTile(
                    title: Text(logg.event),
                    trailing: Text(
                      "id (S.E.P.): ${logg.id.substring(logg.id.length - 6)}",
                    ),
                    subtitle: Text("${Util.format(tid)}"),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Ingen registreringer ennå'));
          }
        },
      ),
    );
  }
}
