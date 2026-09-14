enum CaregiverRole {
  primaryCaregiver,
  caregiver,
  professionalCaregiver;

  static CaregiverRole fromJson(String value) {
    switch (value) {
      case 'primary_caregiver':
        return CaregiverRole.primaryCaregiver;
      case 'caregiver':
        return CaregiverRole.caregiver;
      case 'professional_caregiver':
        return CaregiverRole.professionalCaregiver;
      default:
        throw ArgumentError('Unknown CaregiverRole: $value');
    }
  }

  String toJson() {
    switch (this) {
      case CaregiverRole.primaryCaregiver:
        return 'primary_caregiver';
      case CaregiverRole.caregiver:
        return 'caregiver';
      case CaregiverRole.professionalCaregiver:
        return 'professional_caregiver';
    }
  }
}

class Caregiver {
  final String id;
  final String name;
  final String initials;
  final String relationToPatient;
  final CaregiverRole role;
  final bool isAppOwner;

  Caregiver({
    required this.id,
    required this.name,
    required this.initials,
    required this.relationToPatient,
    required this.role,
    required this.isAppOwner,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      id: json['id'] as String,
      name: json['name'] as String,
      initials: json['initials'] as String,
      relationToPatient: json['relation_to_patient'] as String,
      role: CaregiverRole.fromJson(json['role'] as String),
      isAppOwner: json['is_app_owner'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'initials': initials,
      'relation_to_patient': relationToPatient,
      'role': role.toJson(),
      'is_app_owner': isAppOwner,
    };
  }
}
