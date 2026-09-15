import 'package:flutter/material.dart';
import 'package:refactored_pancake/models/pill_model.dart';
import 'package:refactored_pancake/services/pill_service.dart';

class AddPillScreen extends StatefulWidget {
  final PillService pillService;

  const AddPillScreen({super.key, required this.pillService});

  @override
  State<AddPillScreen> createState() => _AddPillScreenState();
}

class _AddPillScreenState extends State<AddPillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pillNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _tabletsController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _pillNameController.dispose();
    _dosageController.dispose();
    _tabletsController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _addPill() {
    if (_formKey.currentState!.validate()) {
      final pill = PillModel(
        pillName: _pillNameController.text,
        dosage: _dosageController.text,
        tablets: int.parse(_tabletsController.text),
        time: _timeController.text,
        isTaken: false,
        markedByName: 'Sarah',
      );
      widget.pillService.addPill(pill);
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pill'),
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
                          controller: _pillNameController,
                          decoration: const InputDecoration(
                            labelText: 'Pill Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.medication),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a pill name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _dosageController,
                          decoration: const InputDecoration(
                            labelText: 'Dosage (e.g. 500mg)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.scale),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a dosage';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _tabletsController,
                          decoration: const InputDecoration(
                            labelText: 'Number of Tablets',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of tablets';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: 'Time (e.g. 8:00 AM)',
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
                              onPressed: _addPill,
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
                              label: const Text('Add Pill'),
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

