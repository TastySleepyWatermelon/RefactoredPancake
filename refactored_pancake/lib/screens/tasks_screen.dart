import 'package:flutter/material.dart';

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
      body: Column(
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
        ],
      ),
    );
  }
}
