import 'package:flutter/material.dart';

class LoggModal extends StatefulWidget {
  const LoggModal({super.key, required this.onAdd});

  final void Function(DateTime) onAdd;

  @override
  State<LoggModal> createState() => _LoggModalState();
}

class _LoggModalState extends State<LoggModal> {
  void _presentTimePicker() async {
    final now = DateTime.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;
    widget.onAdd(
      DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime!.hour,
        pickedTime.minute,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: _presentTimePicker, child: Text('Velg tid')),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Avbryt'),
        ),
      ],
    );
  }
}
