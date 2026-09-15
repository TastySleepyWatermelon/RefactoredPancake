import 'package:flutter/material.dart';
import 'package:refactored_pancake/models/visit_model.dart';
import 'package:refactored_pancake/services/visit_service.dart';

class AddVisitScreen extends StatefulWidget {
  final VisitService visitService;

  const AddVisitScreen({super.key, required this.visitService});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _visitNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _visitNameController.dispose();
    _doctorNameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _addVisit() {
    if (_formKey.currentState!.validate()) {
      final visit = VisitModel(
        visitName: _visitNameController.text,
        doctorName: _doctorNameController.text,
        day: _dayController.text,
        month: _monthController.text.toUpperCase(),
        time: _timeController.text,
        isHandled: false,
        markedByName: 'John',
      );
      widget.visitService.addVisit(visit);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Visit'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 16,
                      children: [
                        TextFormField(
                          controller: _visitNameController,
                          decoration: const InputDecoration(
                            labelText: 'Visit Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.local_hospital),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a visit name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _doctorNameController,
                          decoration: const InputDecoration(
                            labelText: 'Doctor Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the doctor\'s name';
                            }
                            return null;
                          },
                        ),
                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _dayController,
                                decoration: const InputDecoration(
                                  labelText: 'Day (e.g. 22)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter day';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _monthController,
                                decoration: const InputDecoration(
                                  labelText: 'Month (e.g. SEP)',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.date_range),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter month';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: 'Time (e.g. 10:00 AM)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.schedule),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a time';
                            }
                            return null;
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: FilledButton.icon(
                              onPressed: _addVisit,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(180, 56),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              icon: const Icon(Icons.add, size: 24),
                              label: const Text('Add Visit'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

