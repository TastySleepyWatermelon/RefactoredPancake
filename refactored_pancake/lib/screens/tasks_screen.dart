import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final pills = _pillService.getPills();
    final visits = _visitService.getVisits();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
                          medicationName: pill.medicationName,
                          dosage: pill.dosage,
                          tablets: pill.tablets,
                          time: pill.time,
                          isTaken: pill.isTaken,
                          onMarkAsTaken: () {},
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
                          isHandled: visit.isHandled,
                          onMarkAsHandled: () {},
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
