import 'package:flutter/material.dart';

class VisitWidget extends StatelessWidget {
  final String visitName;
  final String doctorName;
  final String day;
  final String month;
  final String time;
  final bool isHandled;
  final String markedByName;
  final VoidCallback? onMarkAsHandled;

  const VisitWidget({
    super.key,
    required this.visitName,
    required this.doctorName,
    required this.day,
    required this.month,
    required this.time,
    required this.isHandled,
    required this.markedByName,
    this.onMarkAsHandled,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visitName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$doctorName • $day $month',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            if (isHandled)
              Text(
                'Handled and confirmed by $markedByName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: onMarkAsHandled,
                  child: const Text('Mark as handled'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
