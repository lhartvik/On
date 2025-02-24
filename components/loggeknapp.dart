import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';

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
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextStyle style = widget.theme.textTheme.displaySmall!
        .copyWith(color: widget.theme.colorScheme.onPrimary);
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: widget.theme.colorScheme.primary,
        minimumSize: Size.fromHeight(40));
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: ElevatedButton(
            style: buttonStyle,
            onPressed: (widget.disabled || _isLoading)
                ? null
                : () async {
                    LocalDBHelper.instance.insert(widget.tittel);
                    widget.action();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Registrert ${widget.tittel} '),
                      action: SnackBarAction(
                        label: 'Endre tidspunkt',
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ));
                  },
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: _isLoading
                  ? Text('Logger...', style: style)
                  : Text(widget.tittel, style: style),
            )),
      ),
    );
  }
}
