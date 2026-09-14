enum AppointmentStatus {
  upcoming;

  static AppointmentStatus fromJson(String value) {
    switch (value) {
      case 'upcoming':
        return AppointmentStatus.upcoming;
      default:
        throw ArgumentError('Unknown AppointmentStatus: $value');
    }
  }

  String toJson() => name;
}

class Appointment {
  final String id;
  final String patientId;
  final String type;
  final String providerName;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final String? companionId;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.type,
    required this.providerName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.companionId,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      type: json['type'] as String,
      providerName: json['provider_name'] as String,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      location: json['location'] as String,
      companionId: json['companion_id'] as String?,
      status: AppointmentStatus.fromJson(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'type': type,
      'provider_name': providerName,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'companion_id': companionId,
      'status': status.toJson(),
    };
  }
}
