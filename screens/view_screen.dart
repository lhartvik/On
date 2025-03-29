import 'package:flutter/material.dart';
import 'package:onlight/db/local_db_helper.dart';
import 'package:onlight/model/logg.dart';
import 'package:onlight/util/util.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  void _handleLongPress(Logg logg) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;
    var pickedDateTime = Util.today(pickedTime);

    Logg newLogg = Logg(
      id: logg.id,
      event: logg.event,
      timestamp: pickedDateTime.toIso8601String(),
    );
    LocalDBHelper.instance.update(newLogg, logg).then((log) {
      setState(() {});
    });
  }

  void onDismissed(Logg logg) {
    LocalDBHelper.instance.delete(logg.id).then((id) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${logg.event}, ${Util.format(DateTime.parse(logg.timestamp).toLocal())} removed',
            ),
            action: SnackBarAction(
              label: 'Angre',
              onPressed: () {
                LocalDBHelper.instance.insert(
                  logg.event,
                  id: logg.id,
                  tidspunkt: DateTime.parse(logg.timestamp).toUtc(),
                );
                setState(() {});
              },
            ),
          ),
        );
      }
    });
  }

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
                return InkWell(
                  onLongPress: () {
                    _handleLongPress(logg);
                  },
                  child: Dismissible(
                    key: ValueKey(logg.id),
                    onDismissed: (direction) {
                      onDismissed(logg);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(logg.event),
                        trailing: Text(Util.format(tid)),
                      ),
                    ),
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
