import 'package:flutter/material.dart';
import 'package:on_app/db/database_helper.dart';
import 'package:on_app/model/logg.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DatabaseHelper.instance.readAllLogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<Logg> logs = snapshot.data!;
              print(logs.length);
              return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    Logg logg = logs[index];
                    return Card(
                        child: ListTile(
                      title: Text(logg.event),
                      subtitle: Text(logg.timestamp),
                    ));
                  });
            } else {
              return Placeholder();
            }
          }),
    );
  }
}
