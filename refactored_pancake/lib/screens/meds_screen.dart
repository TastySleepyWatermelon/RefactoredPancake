import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/medication.dart';
import '../services/database_service.dart';

class MedsScreen extends StatefulWidget {
  const MedsScreen({super.key});

  @override
  State<MedsScreen> createState() => _MedsScreenState();
}

class _MedsScreenState extends State<MedsScreen> {
  final _databaseService = DatabaseService();
  late Future<List<Medication>> _medicationsFuture;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  ColorScheme get _colors => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _medicationsFuture = _databaseService.getMedications();
  }

  void _reload() {
    setState(() {
      _medicationsFuture = _databaseService.getMedications();
    });
  }

  Future<void> _markAsTaken(Medication medication) async {
    if (medication.id == null) return;
    await _databaseService.markMedicationTaken(medication.id!, 'Caregiver');
    _reload();
  }

  Future<void> _openAddMedicationSheet() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddMedicationSheet(
        databaseService: _databaseService,
      ),
    );
    if (created == true) {
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.surface,
      body: SafeArea(
        child: FutureBuilder<List<Medication>>(
          future: _medicationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Could not load medications',
                  style: GoogleFonts.inter(color: _colors.onSurfaceVariant),
                ),
              );
            }

            final medications = snapshot.data ?? [];
            final morning = medications
                .where((m) => m.period == MedicationPeriod.morning)
                .toList();
            final afternoon = medications
                .where((m) => m.period == MedicationPeriod.afternoon)
                .toList();
            final evening = medications
                .where((m) => m.period == MedicationPeriod.evening)
                .toList();

            return Column(
              children: [
                _buildHeader(medications),
                Expanded(
                  child: medications.isEmpty
                      ? Center(
                          child: Text(
                            'No medications scheduled',
                            style: GoogleFonts.inter(
                              color: _colors.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          children: [
                            if (morning.isNotEmpty)
                              _buildSection('Morning', morning),
                            if (afternoon.isNotEmpty)
                              _buildSection('Afternoon', afternoon),
                            if (evening.isNotEmpty)
                              _buildSection('Evening', evening),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(List<Medication> medications) {
    String? dateLabel;
    if (medications.isNotEmpty) {
      final parsed = DateTime.tryParse(medications.first.scheduledDate);
      if (parsed != null) {
        dateLabel = '${_months[parsed.month - 1]} ${parsed.day}';
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dad's medications",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _colors.onSurface,
                  ),
                ),
                if (dateLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    dateLabel,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: _colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: _colors.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _openAddMedicationSheet,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(Icons.add, color: _colors.onPrimary, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Medication> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 4),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: _colors.onSurfaceVariant,
              ),
            ),
          ),
          ...items.map(_buildMedicationCard),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    final missed = medication.status == MedicationStatus.missedYesterday;
    final taken = medication.status == MedicationStatus.taken;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: missed ? Border.all(color: _colors.error, width: 1.2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (missed) _buildMissedBanner(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusIcon(medication.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${medication.dosage} • ${medication.form}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _statusLabel(medication),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _statusColor(medication.status),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    medication.scheduledTime,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!taken)
                    ElevatedButton(
                      onPressed: () => _markAsTaken(medication),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _colors.primary,
                        foregroundColor: _colors.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Mark as Taken',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMissedBanner() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: _colors.error),
          const SizedBox(width: 6),
          Text(
            'Missed dose yesterday',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _colors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MedicationStatus status) {
    final IconData icon;
    switch (status) {
      case MedicationStatus.taken:
        icon = Icons.check_circle;
        break;
      case MedicationStatus.dueSoon:
        icon = Icons.schedule;
        break;
      case MedicationStatus.dueLater:
        icon = Icons.schedule_outlined;
        break;
      case MedicationStatus.missedYesterday:
        icon = Icons.warning_amber_rounded;
        break;
    }
    final color = _statusColor(status);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  Color _statusColor(MedicationStatus status) {
    switch (status) {
      case MedicationStatus.taken:
        return _colors.primary;
      case MedicationStatus.dueSoon:
        return _colors.tertiary;
      case MedicationStatus.dueLater:
        return _colors.onSurfaceVariant;
      case MedicationStatus.missedYesterday:
        return _colors.error;
    }
  }

  String _statusLabel(Medication medication) {
    switch (medication.status) {
      case MedicationStatus.taken:
        return medication.confirmedBy != null
            ? 'Taken • confirmed by ${medication.confirmedBy}'
            : 'Taken';
      case MedicationStatus.dueSoon:
        return 'Due soon';
      case MedicationStatus.dueLater:
        return 'Due later';
      case MedicationStatus.missedYesterday:
        return 'Due today';
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      backgroundColor: _colors.surfaceContainerHighest,
      selectedItemColor: _colors.primary,
      unselectedItemColor: _colors.onSurfaceVariant,
      selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: 'Schedule'),
        BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined), label: 'Medications'),
        BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined), label: 'Tasks'),
        BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined), label: 'Assistant'),
      ],
    );
  }
}

class _AddMedicationSheet extends StatefulWidget {
  const _AddMedicationSheet({required this.databaseService});

  final DatabaseService databaseService;

  @override
  State<_AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<_AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _formController = TextEditingController();

  MedicationPeriod _period = MedicationPeriod.morning;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _saving = false;

  ColorScheme get _colors => Theme.of(context).colorScheme;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _formController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final scheduledDate =
          '${_date.year.toString().padLeft(4, '0')}-'
          '${_date.month.toString().padLeft(2, '0')}-'
          '${_date.day.toString().padLeft(2, '0')}';
      final medication = Medication(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        form: _formController.text.trim(),
        period: _period,
        scheduledDate: scheduledDate,
        scheduledTime: _time.format(context),
        status: MedicationStatus.dueLater,
      );
      await widget.databaseService.createMedication(medication);
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          color: _colors.surfaceContainerHighest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Medication',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _colors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(labelText: 'Dosage'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _formController,
                  decoration:
                      const InputDecoration(labelText: 'Form (e.g. Tablet)'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Required'
                          : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<MedicationPeriod>(
                  initialValue: _period,
                  decoration: const InputDecoration(labelText: 'Period'),
                  items: MedicationPeriod.values
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name[0].toUpperCase() +
                                p.name.substring(1)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _period = value);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickDate,
                        child: Text(
                            '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickTime,
                        child: Text(_time.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colors.primary,
                      foregroundColor: _colors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _saving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _colors.onPrimary,
                            ),
                          )
                        : Text(
                            'Save',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
