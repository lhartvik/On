import 'package:flutter/material.dart';
import 'package:onlight/db/local_db_helper.dart';
import 'package:onlight/notifiers/statistics.dart';
import 'package:onlight/util/util.dart';
import 'package:provider/provider.dart';

class Loggeknapp extends StatefulWidget {
  const Loggeknapp({super.key, required this.tittel});

  final String tittel;

  @override
  State<Loggeknapp> createState() => _LoggeknappState();
}

class _LoggeknappState extends State<Loggeknapp> {
  @override
  Widget build(BuildContext context) {
    final stats = Provider.of<Statistics>(context, listen: false);
    ThemeData theme = Theme.of(context);

    void update() {
      stats.updateLastMedicineTaken();
      stats.updateLastLog();
    }

    void handleTap() async {
      DateTime tid = DateTime.now().toUtc();
      LocalDBHelper.instance.insert(widget.tittel, tidspunkt: tid).then((x) {
        update();
      });
    }

    void handleLongClick() async {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime == null) return;
      var pickedDateTime = Util.todayOrYesterday(pickedTime);
      LocalDBHelper.instance
          .insert(widget.tittel, tidspunkt: pickedDateTime)
          .then((log) {
            update();
          });
    }

    return Center(
      child: ElevatedButton(
        onLongPress: handleLongClick,
        onPressed: handleTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(200, 50),
        ),
        child: Text(widget.tittel, style: theme.textTheme.titleLarge?.
                  copyWith(color: theme.colorScheme.onPrimary)),
      ),
    );
  }
}
