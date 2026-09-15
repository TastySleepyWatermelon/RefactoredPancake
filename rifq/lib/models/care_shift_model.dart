enum ShiftStatus {
  active,
  upcoming,
  completed,
}

class CareShiftModel {
  final String id;
  final String caregiverName;
  final String caregiverRole;
  final String shiftTitle;
  final String startTime;
  final String endTime;
  final String duration;
  final String dutiesSummary;
  final ShiftStatus status;
  final String avatarInitials;
  final String? phoneNumber;

  const CareShiftModel({
    required this.id,
    required this.caregiverName,
    required this.caregiverRole,
    required this.shiftTitle,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.dutiesSummary,
    required this.status,
    required this.avatarInitials,
    this.phoneNumber,
  });

  CareShiftModel copyWith({
    String? id,
    String? caregiverName,
    String? caregiverRole,
    String? shiftTitle,
    String? startTime,
    String? endTime,
    String? duration,
    String? dutiesSummary,
    ShiftStatus? status,
    String? avatarInitials,
    String? phoneNumber,
  }) {
    return CareShiftModel(
      id: id ?? this.id,
      caregiverName: caregiverName ?? this.caregiverName,
      caregiverRole: caregiverRole ?? this.caregiverRole,
      shiftTitle: shiftTitle ?? this.shiftTitle,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      dutiesSummary: dutiesSummary ?? this.dutiesSummary,
      status: status ?? this.status,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

