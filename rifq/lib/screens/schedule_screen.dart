import 'package:flutter/material.dart';
import 'package:rifq/models/care_shift_model.dart';
import 'package:rifq/widgets/care_shift_card.dart';
import 'package:rifq/widgets/shift_swap_dialog.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _fullWeekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _shortWeekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  late DateTime _selectedDate;
  late DateTime _weekStartDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    // Start week on Monday of current selected week
    _weekStartDate = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  void _previousWeek() {
    setState(() {
      _weekStartDate = _weekStartDate.subtract(const Duration(days: 7));
      _selectedDate = _weekStartDate;
    });
  }

  void _nextWeek() {
    setState(() {
      _weekStartDate = _weekStartDate.add(const Duration(days: 7));
      _selectedDate = _weekStartDate;
    });
  }

  void _jumpToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _selectedDate = today;
      _weekStartDate = today.subtract(Duration(days: today.weekday - 1));
    });
  }

  List<CareShiftModel> _getShiftsForDate(DateTime date) {
    final today = DateTime.now();
    final isToday = _isSameDay(date, today);

    // Three shifts scheduled for each day
    return [
      CareShiftModel(
        id: 'shift-morning-${date.day}',
        caregiverName: 'Sarah Johnson',
        caregiverRole: 'Daughter',
        shiftTitle: 'Morning Shift',
        startTime: '07:00 AM',
        endTime: '01:00 PM',
        duration: '6 hrs',
        dutiesSummary:
            'Breakfast, morning Lisinopril medication, blood pressure check & physical walk',
        status: isToday ? ShiftStatus.active : ShiftStatus.upcoming,
        avatarInitials: 'SJ',
        phoneNumber: '+1-555-0142',
      ),
      CareShiftModel(
        id: 'shift-afternoon-${date.day}',
        caregiverName: 'Mike Johnson',
        caregiverRole: 'Son',
        shiftTitle: 'Afternoon Shift',
        startTime: '01:00 PM',
        endTime: '07:00 PM',
        duration: '6 hrs',
        dutiesSummary:
            'Lunch, doctor appointment visit, blood sugar reading & garden relaxation',
        status: ShiftStatus.upcoming,
        avatarInitials: 'MJ',
        phoneNumber: '+1-555-0189',
      ),
      CareShiftModel(
        id: 'shift-night-${date.day}',
        caregiverName: 'Layla Johnson',
        caregiverRole: 'Granddaughter',
        shiftTitle: 'Night Shift',
        startTime: '07:00 PM',
        endTime: '07:00 AM',
        duration: '12 hrs',
        dutiesSummary:
            'Dinner, evening Atorvastatin medication, night routine & sleep monitoring',
        status: ShiftStatus.upcoming,
        avatarInitials: 'LJ',
        phoneNumber: '+1-555-0210',
      ),
    ];
  }

  Future<void> _openShiftSwapDialog() async {
    final result = await ShiftSwapDialog.show(context);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Swap request sent to ${result.swapWith}!',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final isToday = _isSameDay(_selectedDate, now);
    final shifts = _getShiftsForDate(_selectedDate);

    final weekdayName = _fullWeekdays[_selectedDate.weekday - 1];
    final monthName = _months[_selectedDate.month - 1];
    final formattedDayTitle = isToday
        ? 'Today, $monthName ${_selectedDate.day}'
        : '$weekdayName, $monthName ${_selectedDate.day}';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Care Schedule'),
            Text(
              'Caring for Robert Johnson',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (!isToday)
            TextButton.icon(
              onPressed: _jumpToToday,
              icon: const Icon(Icons.today, size: 18),
              label: const Text('Today'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Simple Calendar on the Top
                  _buildCalendarSection(context),

                  const SizedBox(height: 20),

                  // 2. Section Title: Current Day & Shift Overview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                formattedDayTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Today',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '3 Caregivers scheduled • 24h Coverage',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3. Three Widgets of People and Their Schedule Timings
                ...shifts.map((shift) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CareShiftCard(
                      shift: shift,
                      onContactTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Contacting ${shift.caregiverName} (${shift.caregiverRole})...',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

          // 4. Request Shift Swap Button at the bottom
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _openShiftSwapDialog,
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text(
                    'Request Shift Swap',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();

    final currentMonthYear =
        '${_months[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            // Calendar Header: Month/Year navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 4),
                    const Icon(Icons.calendar_month, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      currentMonthYear,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: 'Previous week',
                      onPressed: _previousWeek,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: 'Next week',
                      onPressed: _nextWeek,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Horizontal Days Strip (Monday to Sunday)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final dayDate = _weekStartDate.add(Duration(days: index));
                final isSelected = _isSameDay(dayDate, _selectedDate);
                final isCurrentRealToday = _isSameDay(dayDate, now);
                final shortWeekday = _shortWeekdays[dayDate.weekday - 1];

                return InkWell(
                  onTap: () => _selectDate(dayDate),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : (isCurrentRealToday
                              ? colorScheme.primaryContainer.withValues(alpha: 0.35)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(14),
                      border: isCurrentRealToday && !isSelected
                          ? Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.6),
                              width: 1.2,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          shortWeekday,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dayDate.day}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Indicator dot showing care shift coverage
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
