enum MedicationPeriod {
  morning,
  afternoon,
  evening;

  static MedicationPeriod fromJson(String value) {
    switch (value) {
      case 'morning':
        return MedicationPeriod.morning;
      case 'afternoon':
        return MedicationPeriod.afternoon;
      case 'evening':
        return MedicationPeriod.evening;
      default:
        throw ArgumentError('Unknown MedicationPeriod: $value');
    }
  }

  String toJson() => name;
}

enum MedicationStatus {
  taken,
  dueSoon,
  dueLater,
  missedYesterday;

  static MedicationStatus fromJson(String value) {
    switch (value) {
      case 'taken':
        return MedicationStatus.taken;
      case 'due_soon':
        return MedicationStatus.dueSoon;
      case 'due_later':
        return MedicationStatus.dueLater;
      case 'missed_yesterday':
        return MedicationStatus.missedYesterday;
      default:
        throw ArgumentError('Unknown MedicationStatus: $value');
    }
  }

  String toJson() {
    switch (this) {
      case MedicationStatus.taken:
        return 'taken';
      case MedicationStatus.dueSoon:
        return 'due_soon';
      case MedicationStatus.dueLater:
        return 'due_later';
      case MedicationStatus.missedYesterday:
        return 'missed_yesterday';
    }
  }
}

class Medication {
  final String? id;
  final String name;
  final String dosage;
  final String form;
  final MedicationPeriod period;
  final String scheduledDate;
  final String scheduledTime;
  final MedicationStatus status;
  final String? confirmedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.period,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    this.confirmedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String?,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      form: json['form'] as String,
      period: MedicationPeriod.fromJson(json['period'] as String),
      scheduledDate: json['scheduled_date'] as String,
      scheduledTime: json['scheduled_time'] as String,
      status: MedicationStatus.fromJson(json['status'] as String),
      confirmedBy: json['confirmed_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'form': form,
      'period': period.toJson(),
      'scheduled_date': scheduledDate,
      'scheduled_time': scheduledTime,
      'status': status.toJson(),
      'confirmed_by': confirmedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
