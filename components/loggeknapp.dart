import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/screens/logg_modal.dart';

class Loggeknapp extends StatefulWidget {
  const Loggeknapp({super.key, required this.tittel});

  final String tittel;

  @override
  State<Loggeknapp> createState() => _LoggeknappState();
}

class _LoggeknappState extends State<Loggeknapp> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    void handleLongClick() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder:
            (ctx) => LoggModal(
              onAdd:
                  (DateTime tidspunkt) => LocalDBHelper.instance.insert(
                    widget.tittel,
                    tidspunkt: tidspunkt,
                  ),
            ),
      );
    }

    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => LocalDBHelper.instance.insert(widget.tittel),
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
