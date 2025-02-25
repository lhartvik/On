import 'package:flutter/material.dart';
import 'package:on_app/db/sqflite_helper.dart';

import '../model/plan.dart';
import '../widgets/new_plan.dart';
import '../widgets/plan_list.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final List<Plan> _plannedMeds = [];

  void _addPlan(Plan plan) {
    setState(() {
      _plannedMeds.add(plan);
    });
    LocalDBHelper.instance.insertPlan(plan);
  }

  void _openAppPlanOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewPlan(onAddPlan: _addPlan),
    );
  }

  void copyPlan(Plan plan) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewPlan(onAddPlan: _addPlan, copyPlan: plan),
    );
  }

  void _removePlan(Plan plan) {
    LocalDBHelper.instance.removePlan(plan.id);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${plan.medicine} fjernet'),
        action: SnackBarAction(
          label: 'IKKE SLETT LIKEVEL',
          onPressed: () {
            LocalDBHelper.instance.insertPlan(plan);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAppPlanOverlay,
          ),
        ],
      ),
      body: FutureBuilder(
        builder: (ctx, planData) {
          if (planData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (planData.connectionState == ConnectionState.done &&
              planData.hasData &&
              planData.data!.isNotEmpty) {
            return PlanList(
              plannedMeds: planData.data as List<Plan>,
              onRemovePlan: _removePlan,
              copyPlan: copyPlan,
            );
          } else if (planData.hasError) {
            return Center(child: Text('Error: ${planData.error}'));
          } else {
            return const Center(child: Text('Ingen plan ennå'));
          }
        },
        future: LocalDBHelper.instance.getMedicinePlan(),
      ),
    );
  }
}
