import 'package:flutter/material.dart';
import 'package:rifq/models/care_shift_model.dart';

class CareShiftCard extends StatelessWidget {
  final CareShiftModel shift;
  final VoidCallback? onContactTap;

  const CareShiftCard({
    super.key,
    required this.shift,
    this.onContactTap,
  });

  IconData _getShiftIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('morning')) {
      return Icons.wb_sunny_rounded;
    } else if (lower.contains('afternoon')) {
      return Icons.wb_twilight_rounded;
    } else {
      return Icons.bedtime_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isActive = shift.status == ShiftStatus.active;

    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.7),
          width: isActive ? 1.8 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Caregiver Info & Status Badge
            Row(
              children: [
                // Caregiver Avatar
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    shift.avatarInitials,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Name and Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.caregiverName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        shift.caregiverRole,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                _buildStatusBadge(context, shift.status),
              ],
            ),

            const SizedBox(height: 14),

            // Middle Box: Shift Title & Time Frame
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                    : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getShiftIcon(shift.shiftTitle),
                    size: 20,
                    color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shift.shiftTitle,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${shift.startTime} – ${shift.endTime} (${shift.duration})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onContactTap != null)
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                      color: colorScheme.primary,
                      tooltip: 'Message ${shift.caregiverName}',
                      onPressed: onContactTap,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Duties / Activities Summary
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.task_alt_rounded,
                  size: 16,
                  color: colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    shift.dutiesSummary,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ShiftStatus status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeBg;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case ShiftStatus.active:
        badgeBg = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        label = 'Active Now';
        icon = Icons.fiber_manual_record;
        break;
      case ShiftStatus.upcoming:
        badgeBg = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurfaceVariant;
        label = 'Upcoming';
        icon = Icons.schedule_rounded;
        break;
      case ShiftStatus.completed:
        badgeBg = colorScheme.surfaceContainerLow;
        textColor = colorScheme.outline;
        label = 'Completed';
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: status == ShiftStatus.active ? 8 : 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
