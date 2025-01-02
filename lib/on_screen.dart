import 'package:flutter/material.dart';
import 'package:on_app/components/loggeknapp.dart';
import 'package:on_app/db/database_helper.dart';

class OnScreen extends StatelessWidget {
  const OnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 50,
        children: [
          for (var title in ['Ta medisin', 'On', 'Off'])
            Loggeknapp(tittel: title, theme: theme),
          ElevatedButton(
              onPressed: () {
                DatabaseHelper.instance.clearAll();
              },
              child: Text('Clear all'))
        ],
      ),
    );
  }
}
