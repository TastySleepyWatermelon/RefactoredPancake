import 'package:flutter/material.dart';
import 'package:refactored_pancake/models/pill_model.dart';
import 'package:refactored_pancake/models/visit_model.dart';
import 'package:refactored_pancake/screens/add_pill_screen.dart';
import 'package:refactored_pancake/screens/add_visit_screen.dart';
import 'package:refactored_pancake/services/pill_service.dart';
import 'package:refactored_pancake/services/visit_service.dart';
import 'package:refactored_pancake/widgets/pill_widget.dart';
import 'package:refactored_pancake/widgets/visit_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'all';
  final PillService _pillService = PillService();
  final VisitService _visitService = VisitService();
  final Set<PillModel> _takenPills = <PillModel>{};
  final Set<VisitModel> _handledVisits = <VisitModel>{};

  void _onMarkAsTaken(PillModel pill) {
    setState(() {
      _takenPills.add(pill);
    });
  }

  void _onMarkAsHandled(VisitModel visit) {
    setState(() {
      _handledVisits.add(visit);
    });
  }

  void _navigateToAddPill() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddPillScreen(pillService: _pillService),
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  void _navigateToAddVisit() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddVisitScreen(visitService: _visitService),
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pills = _pillService.getPills();
    final visits = _visitService.getVisits();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SegmentedButton(
              selected: {_selectedFilter},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedFilter = newSelection.first;
                });
              },
              segments: const [
                ButtonSegment(
                  value: 'all',
                  label: Text('All'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment(
                  value: 'pills',
                  label: Text('Pills'),
                  icon: Icon(Icons.medication),
                ),
                ButtonSegment(
                  value: 'visits',
                  label: Text('Visits'),
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (_selectedFilter == 'all' || _selectedFilter == 'pills')
                    ...pills.map(
                      (pill) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PillWidget(
                          pillName: pill.pillName,
                          dosage: pill.dosage,
                          tablets: pill.tablets,
                          time: pill.time,
                          isTaken: pill.isTaken || _takenPills.contains(pill),
                          onMarkAsTaken: () => _onMarkAsTaken(pill),
                        ),
                      ),
                    ),
                  if (_selectedFilter == 'all' || _selectedFilter == 'visits')
                    ...visits.map(
                      (visit) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: VisitWidget(
                          visitName: visit.visitName,
                          doctorName: visit.doctorName,
                          day: visit.day,
                          month: visit.month,
                          time: visit.time,
                          isHandled:
                              visit.isHandled || _handledVisits.contains(visit),
                          onMarkAsHandled: () => _onMarkAsHandled(visit),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const Icon(Icons.medication),
                    title: const Text('Add Pill'),
                    subtitle: const Text('Add a new prescribed pill'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _navigateToAddPill();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const Icon(Icons.location_on),
                    title: const Text('Add Visit'),
                    subtitle: const Text('Add a new scheduled visit'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _navigateToAddVisit();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
