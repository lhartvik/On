import 'package:flutter/material.dart';
import 'package:on_app/db/supabase_helper.dart';

class Loggeknapp extends StatelessWidget {
  const Loggeknapp({
    super.key,
    required this.tittel,
    required this.theme,
  });

  final String tittel;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    TextStyle style = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        minimumSize: Size.fromHeight(40));
    return Center(
      child: ElevatedButton(
          style: buttonStyle,
          onPressed: () {
            SupabaseHelper.instance.insert(tittel);
          },
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(tittel, style: style),
          )),
    );
  }
}
