import 'package:flutter/material.dart';
import 'package:on_app/model/plan.dart';
import 'package:on_app/widgets/plan_widget.dart';

class PlanList extends StatelessWidget {
  final List<Plan> plannedMeds;
  final void Function(Plan plan) onRemovePlan;

  final void Function(Plan plan) copyPlan;

  const PlanList({
    super.key,
    required this.plannedMeds,
    required this.onRemovePlan,
    required this.copyPlan,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plannedMeds.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(plannedMeds),
        onDismissed: (direction) {
          onRemovePlan(plannedMeds[index]);
        },
        child: PlanWidget(
          plan: plannedMeds[index],
          copyPlan: () {
            copyPlan(plannedMeds[index]);
          },
        ),
      ),
    );
  }
}
