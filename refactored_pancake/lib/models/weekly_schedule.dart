import 'shift.dart';

class WeeklyScheduleDay {
  final String date;
  final String weekday;
  final List<Shift> shifts;

  WeeklyScheduleDay({
    required this.date,
    required this.weekday,
    required this.shifts,
  });

  factory WeeklyScheduleDay.fromJson(Map<String, dynamic> json) {
    return WeeklyScheduleDay(
      date: json['date'] as String,
      weekday: json['weekday'] as String,
      shifts: (json['shifts'] as List)
          .map((e) => Shift.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weekday': weekday,
      'shifts': shifts.map((e) => e.toJson()).toList(),
    };
  }
}

class WeeklySchedule {
  final String weekStart;
  final String weekEnd;
  final List<WeeklyScheduleDay> days;

  WeeklySchedule({
    required this.weekStart,
    required this.weekEnd,
    required this.days,
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) {
    return WeeklySchedule(
      weekStart: json['week_start'] as String,
      weekEnd: json['week_end'] as String,
      days: (json['days'] as List)
          .map((e) => WeeklyScheduleDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_start': weekStart,
      'week_end': weekEnd,
      'days': days.map((e) => e.toJson()).toList(),
    };
  }
}
