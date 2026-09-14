enum ActivityType {
  medicationConfirmed,
  note,
  shiftConfirmed;

  static ActivityType fromJson(String value) {
    switch (value) {
      case 'medication_confirmed':
        return ActivityType.medicationConfirmed;
      case 'note':
        return ActivityType.note;
      case 'shift_confirmed':
        return ActivityType.shiftConfirmed;
      default:
        throw ArgumentError('Unknown ActivityType: $value');
    }
  }

  String toJson() {
    switch (this) {
      case ActivityType.medicationConfirmed:
        return 'medication_confirmed';
      case ActivityType.note:
        return 'note';
      case ActivityType.shiftConfirmed:
        return 'shift_confirmed';
    }
  }
}

class ActivityFeedItem {
  final String id;
  final String actorId;
  final ActivityType type;
  final String message;
  final String date;
  final String time;

  ActivityFeedItem({
    required this.id,
    required this.actorId,
    required this.type,
    required this.message,
    required this.date,
    required this.time,
  });

  factory ActivityFeedItem.fromJson(Map<String, dynamic> json) {
    return ActivityFeedItem(
      id: json['id'] as String,
      actorId: json['actor_id'] as String,
      type: ActivityType.fromJson(json['type'] as String),
      message: json['message'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actor_id': actorId,
      'type': type.toJson(),
      'message': message,
      'date': date,
      'time': time,
    };
  }
}
