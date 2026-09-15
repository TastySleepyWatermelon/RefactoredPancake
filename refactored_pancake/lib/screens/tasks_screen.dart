import 'package:flutter/material.dart';
import 'package:refactored_pancake/widgets/pill_widget.dart';
import 'package:refactored_pancake/widgets/visit_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            Center(
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
                    icon: Icon(Icons.list), // M3 encourages icons in segments
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

            PillWidget(
              dosage: "500mg",
              medicationName: "Paracetamol",
              tablets: 2,
              time: "08:00 AM",
              isTaken: true,
              onMarkAsTaken: () {},
            ),
            PillWidget(
              dosage: "500mg",
              medicationName: "Paracetamol",
              tablets: 2,
              time: "08:00 AM",
              isTaken: false,
              onMarkAsTaken: () {},
            ),

            VisitWidget(
              visitName: "General Checkup",
              doctorName: "Dr. Smith",
              day: "12",
              month: "Oct",
              time: "10:00 AM",
              isHandled: false,
              onMarkAsHandled: () {},
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
