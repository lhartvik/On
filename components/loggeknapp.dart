import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/notifiers/statistics.dart';
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

    void handleLongClick() async {
      final now = DateTime.now().toUtc();
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime == null) return;
      var pickedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      LocalDBHelper.instance.insert(widget.tittel, tidspunkt: pickedDateTime);
      stats.updateLastMedicineTaken(pickedDateTime);
    }

    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            LocalDBHelper.instance.insert(widget.tittel);
            stats.updateLastMedicineTaken(DateTime.now().toUtc());
          },
          onLongPress: handleLongClick,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.95),
          child: Container(
            width: double.infinity,
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
