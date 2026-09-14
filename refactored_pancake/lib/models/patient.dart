enum PatientStatus {
  stable;

  static PatientStatus fromJson(String value) {
    switch (value) {
      case 'stable':
        return PatientStatus.stable;
      default:
        throw ArgumentError('Unknown PatientStatus: $value');
    }
  }

  String toJson() => name;
}

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String initials;
  final int age;
  final PatientStatus status;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.initials,
    required this.age,
    required this.status,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      displayName: json['display_name'] as String,
      initials: json['initials'] as String,
      age: json['age'] as int,
      status: PatientStatus.fromJson(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'display_name': displayName,
      'initials': initials,
      'age': age,
      'status': status.toJson(),
    };
  }
}
