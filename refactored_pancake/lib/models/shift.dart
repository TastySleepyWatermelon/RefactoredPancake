enum ShiftStatus {
  completed,
  now,
  upcoming;

  static ShiftStatus fromJson(String value) {
    switch (value) {
      case 'completed':
        return ShiftStatus.completed;
      case 'now':
        return ShiftStatus.now;
      case 'upcoming':
        return ShiftStatus.upcoming;
      default:
        throw ArgumentError('Unknown ShiftStatus: $value');
    }
  }

  String toJson() => name;
}

class Shift {
  final String id;
  final String caregiverId;
  final String label;
  final String startTime;
  final String endTime;
  final ShiftStatus status;

  Shift({
    required this.id,
    required this.caregiverId,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as String,
      caregiverId: json['caregiver_id'] as String,
      label: json['label'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: ShiftStatus.fromJson(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caregiver_id': caregiverId,
      'label': label,
      'start_time': startTime,
      'end_time': endTime,
      'status': status.toJson(),
    };
  }
}
