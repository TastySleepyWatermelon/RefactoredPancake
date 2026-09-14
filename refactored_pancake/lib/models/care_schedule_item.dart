enum CareScheduleStatus {
  completed,
  dueSoon,
  upcoming;

  static CareScheduleStatus fromJson(String value) {
    switch (value) {
      case 'completed':
        return CareScheduleStatus.completed;
      case 'due_soon':
        return CareScheduleStatus.dueSoon;
      case 'upcoming':
        return CareScheduleStatus.upcoming;
      default:
        throw ArgumentError('Unknown CareScheduleStatus: $value');
    }
  }

  String toJson() {
    switch (this) {
      case CareScheduleStatus.completed:
        return 'completed';
      case CareScheduleStatus.dueSoon:
        return 'due_soon';
      case CareScheduleStatus.upcoming:
        return 'upcoming';
    }
  }
}

class CareScheduleItem {
  final String id;
  final String patientId;
  final String date;
  final String time;
  final String title;
  final List<String>? relatedMedications;
  final String? location;
  final String? assignedToId;
  final CareScheduleStatus status;

  CareScheduleItem({
    required this.id,
    required this.patientId,
    required this.date,
    required this.time,
    required this.title,
    this.relatedMedications,
    this.location,
    this.assignedToId,
    required this.status,
  });

  factory CareScheduleItem.fromJson(Map<String, dynamic> json) {
    return CareScheduleItem(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      relatedMedications: (json['related_medications'] as List?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      assignedToId: json['assigned_to_id'] as String?,
      status: CareScheduleStatus.fromJson(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'date': date,
      'time': time,
      'title': title,
      'related_medications': relatedMedications,
      'location': location,
      'assigned_to_id': assignedToId,
      'status': status.toJson(),
    };
  }
}
