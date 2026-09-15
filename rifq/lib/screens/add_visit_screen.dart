import 'package:flutter/material.dart';
import 'package:rifq/models/visit_model.dart';
import 'package:rifq/services/visit_service.dart';

class AddVisitScreen extends StatefulWidget {
  final VisitService visitService;
  final bool isDialog;

  const AddVisitScreen({
    super.key,
    required this.visitService,
    this.isDialog = true,
  });

  static Future<bool?> show(
    BuildContext context, {
    required VisitService visitService,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AddVisitScreen(
        visitService: visitService,
        isDialog: true,
      ),
    );
  }

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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      const months = [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC'
      ];
      setState(() {
        _dayController.text = picked.day.toString();
        _monthController.text = months[picked.month - 1];
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      setState(() {
        _timeController.text = '$hour:$minute $period';
      });
    }
  }

  void _addVisit() {
    if (_formKey.currentState!.validate()) {
      final visit = VisitModel(
        visitName: _visitNameController.text.trim(),
        doctorName: _doctorNameController.text.trim(),
        day: _dayController.text.trim(),
        month: _monthController.text.trim().toUpperCase(),
        time: _timeController.text.trim(),
        isHandled: false,
        markedByName: 'John',
      );
      widget.visitService.addVisit(visit);
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildFormFields(BuildContext context, {required bool isDialog}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _visitNameController,
            decoration: InputDecoration(
              labelText: 'Visit Name',
              hintText: 'e.g. Annual Checkup',
              prefixIcon: const Icon(Icons.local_hospital_outlined),
              filled: isDialog,
              fillColor: isDialog ? colorScheme.surface : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a visit name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _doctorNameController,
            decoration: InputDecoration(
              labelText: 'Doctor Name',
              hintText: 'e.g. Dr. Sarah Smith',
              prefixIcon: const Icon(Icons.person_outline_rounded),
              filled: isDialog,
              fillColor: isDialog ? colorScheme.surface : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the doctor\'s name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _dayController,
                  decoration: InputDecoration(
                    labelText: 'Day',
                    hintText: 'e.g. 22',
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    filled: isDialog,
                    fillColor: isDialog ? colorScheme.surface : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter day';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _monthController,
                  decoration: InputDecoration(
                    labelText: 'Month',
                    hintText: 'e.g. SEP',
                    prefixIcon: const Icon(Icons.date_range_outlined),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.event_outlined),
                      onPressed: _selectDate,
                      tooltip: 'Pick date',
                    ),
                    filled: isDialog,
                    fillColor: isDialog ? colorScheme.surface : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter month';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _timeController,
            decoration: InputDecoration(
              labelText: 'Time',
              hintText: 'e.g. 10:00 AM',
              prefixIcon: const Icon(Icons.access_time_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.schedule_rounded),
                onPressed: _selectTime,
                tooltip: 'Select time',
              ),
              filled: isDialog,
              fillColor: isDialog ? colorScheme.surface : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a time';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.isDialog) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Visit',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Add a new scheduled visit',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFormFields(context, isDialog: true),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _addVisit,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add Visit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Visit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormFields(context, isDialog: false),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _addVisit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add Visit'),
            ),
          ],
        ),
      ),
    );
  }
}
