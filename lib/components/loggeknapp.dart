import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';
import 'package:on_app/db/supabase_helper.dart';

class Loggeknapp extends StatefulWidget {
  const Loggeknapp({
    super.key,
    required this.tittel,
    required this.theme,
    required this.disabled,
    required this.action,
  });

  final String tittel;
  final ThemeData theme;
  final bool disabled;
  final void Function() action;

  @override
  State<Loggeknapp> createState() => _LoggeknappState();
}

class _LoggeknappState extends State<Loggeknapp> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = widget.theme.textTheme.displaySmall!
        .copyWith(color: widget.theme.colorScheme.onPrimary);
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: widget.theme.colorScheme.primary,
        minimumSize: Size.fromHeight(40));
    return Center(
      child: ElevatedButton(
          style: buttonStyle,
          onPressed: widget.disabled
              ? null
              : () {
                  setState(() {
                    _isLoading = true;
                  });
                  LocalDBHelper.instance.insert(widget.tittel);
                  widget.action();
                  setState(() {
                    _isLoading = false;
                  });
                },
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: _isLoading
                ? CircularProgressIndicator()
                : Text(widget.tittel, style: style),
          )),
    );
  }
}
