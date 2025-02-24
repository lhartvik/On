import 'package:flutter/material.dart';
import 'package:on_app/model/plan.dart';

class PlanWidget extends StatelessWidget {
  final Plan plan;

  final void Function() copyPlan;

  const PlanWidget({super.key, required this.plan, required this.copyPlan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(plan.medicine),
        subtitle: Text(plan.tidString),
        leading: Icon(Icons.medical_services),
        trailing: IconButton(onPressed: copyPlan, icon: Icon(Icons.copy)),
      ),
    );
  }
}
