import 'package:flutter/material.dart';

class ShiftSwapRequestData {
  final String myShift;
  final String swapWith;
  final String? note;

  const ShiftSwapRequestData({
    required this.myShift,
    required this.swapWith,
    this.note,
  });
}

class ShiftSwapDialog extends StatefulWidget {
  final List<String> userShifts;
  final List<String> availableRelatives;

  const ShiftSwapDialog({
    super.key,
    required this.userShifts,
    required this.availableRelatives,
  });

  static Future<ShiftSwapRequestData?> show(
    BuildContext context, {
    List<String>? userShifts,
    List<String>? availableRelatives,
  }) {
    return showDialog<ShiftSwapRequestData>(
      context: context,
      builder: (context) => ShiftSwapDialog(
        userShifts: userShifts ??
            const [
              'Morning Shift • Today (07:00 AM – 01:00 PM)',
              'Afternoon Shift • Tomorrow (01:00 PM – 07:00 PM)',
              'Night Shift • Thursday (07:00 PM – 07:00 AM)',
            ],
        availableRelatives: availableRelatives ??
            const [
              'Anyone (Notify all family members)',
              'Mike Johnson (Son)',
              'Layla Johnson (Granddaughter)',
              'Ahmed Johnson (Brother)',
            ],
      ),
    );
  }

  @override
  State<ShiftSwapDialog> createState() => _ShiftSwapDialogState();
}

class _ShiftSwapDialogState extends State<ShiftSwapDialog> {
  late String _selectedShift;
  late String _selectedRelative;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedShift = widget.userShifts.first;
    _selectedRelative = widget.availableRelatives.first;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.swap_horiz_rounded,
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Shift Swap',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ask relatives to cover your shift',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Select Shift
            Text(
              'Your Shift',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _selectedShift,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.access_time_rounded, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: widget.userShifts.map((shift) {
                return DropdownMenuItem<String>(
                  value: shift,
                  child: Text(
                    shift,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedShift = val);
                }
              },
            ),

            const SizedBox(height: 16),

            // Select Target Caregiver
            Text(
              'Swap With',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _selectedRelative,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.people_alt_outlined, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: widget.availableRelatives.map((relative) {
                return DropdownMenuItem<String>(
                  value: relative,
                  child: Text(
                    relative,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedRelative = val);
                }
              },
            ),

            const SizedBox(height: 16),

            // Reason / Note
            Text(
              'Reason / Note (Optional)',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. Doctor appointment, work conflict...',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.send_rounded, size: 16),
          label: const Text('Send Request'),
          onPressed: () {
            Navigator.of(context).pop(
              ShiftSwapRequestData(
                myShift: _selectedShift,
                swapWith: _selectedRelative,
                note: _reasonController.text.trim().isEmpty
                    ? null
                    : _reasonController.text.trim(),
              ),
            );
          },
        ),
      ],
    );
  }
}
