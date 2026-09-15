import 'package:flutter/material.dart';
import 'package:rifq/models/pill_model.dart';
import 'package:rifq/services/pill_service.dart';

class AddPillScreen extends StatefulWidget {
  final PillService pillService;
  final bool isDialog;

  const AddPillScreen({
    super.key,
    required this.pillService,
    this.isDialog = true,
  });

  static Future<bool?> show(
    BuildContext context, {
    required PillService pillService,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AddPillScreen(
        pillService: pillService,
        isDialog: true,
      ),
    );
  }

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

  Future<void> _selectTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
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

  void _addPill() {
    if (_formKey.currentState!.validate()) {
      final pill = PillModel(
        pillName: _pillNameController.text.trim(),
        dosage: _dosageController.text.trim(),
        tablets: int.parse(_tabletsController.text.trim()),
        time: _timeController.text.trim(),
        isTaken: false,
        markedByName: 'Sarah',
      );
      widget.pillService.addPill(pill);
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
            controller: _pillNameController,
            decoration: InputDecoration(
              labelText: 'Pill Name',
              hintText: 'e.g. Lisinopril',
              prefixIcon: const Icon(Icons.medication_outlined),
              filled: isDialog,
              fillColor: isDialog ? colorScheme.surface : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a pill name';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _dosageController,
            decoration: InputDecoration(
              labelText: 'Dosage',
              hintText: 'e.g. 500mg',
              prefixIcon: const Icon(Icons.scale_outlined),
              filled: isDialog,
              fillColor: isDialog ? colorScheme.surface : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a dosage';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _tabletsController,
            decoration: InputDecoration(
              labelText: 'Number of Tablets',
              hintText: 'e.g. 2',
              prefixIcon: const Icon(Icons.pin_outlined),
              filled: isDialog,
              fillColor: isDialog ? colorScheme.surface : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the number of tablets';
              }
              if (int.tryParse(value.trim()) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _timeController,
            decoration: InputDecoration(
              labelText: 'Time',
              hintText: 'e.g. 8:00 AM',
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
                          Icons.medication_rounded,
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
                              'Add Pill',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Add a new prescribed medication',
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
                        onPressed: _addPill,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add Pill'),
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
        title: const Text('Add Pill'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormFields(context, isDialog: false),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _addPill,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add Pill'),
            ),
          ],
        ),
      ),
    );
  }
}
