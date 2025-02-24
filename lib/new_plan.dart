import 'package:flutter/material.dart';

import 'model/plan.dart';

class NewPlan extends StatefulWidget {
  final void Function(Plan plan) onAddPlan;

  final Plan? copyPlan;

  const NewPlan({super.key, required this.onAddPlan, this.copyPlan});

  @override
  State<StatefulWidget> createState() {
    return _NewPlanState();
  }
}

class _NewPlanState extends State<NewPlan> {
  final _medicineController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _medicineController.dispose();
    super.dispose();
  }

  void _presentTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ??
          widget.copyPlan?.time ??
          TimeOfDay(hour: 12, minute: 0),
    );

    print(pickedTime);
    if (pickedTime == null) {
      return;
    }
    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _submitData() {
    final enteredMedicine = _medicineController.text;

    if (enteredMedicine.isEmpty || _selectedTime == null) {
      return;
    }

    final newPlan = Plan(
      medicine: enteredMedicine,
      time: _selectedTime!,
    );

    widget.onAddPlan(newPlan);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.copyPlan != null && _medicineController.text.isEmpty) {
      _medicineController.text = widget.copyPlan!.medicine;
    }

    _selectedTime ??= widget.copyPlan?.time ?? TimeOfDay(hour: 12, minute: 0);

    return Card(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(labelText: 'Medisin'),
            controller: _medicineController,
            onSubmitted: (_) => _submitData(),
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                      '${_selectedTime!.hour.toString().padLeft(2, '0')}: ${_selectedTime!.minute.toString().padLeft(2, '0')}')),
              IconButton(
                  onPressed: _presentTimePicker, icon: Icon(Icons.access_time)),
              Spacer(),
              ElevatedButton.icon(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(Icons.cancel),
                  label: const Text('Avbryt')),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Legg til plan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
