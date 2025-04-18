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
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: handleTap,
          onLongPress: handleLongClick,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.95),
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Text(
                widget.tittel,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
