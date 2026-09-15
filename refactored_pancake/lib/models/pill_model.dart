class PillModel {
  final String medicationName;
  final String dosage;
  final int tablets;
  final String time;
  final bool isTaken;

  const PillModel({
    required this.medicationName,
    required this.dosage,
    required this.tablets,
    required this.time,
    this.isTaken = false,
  });

  PillModel copyWith({
    String? medicationName,
    String? dosage,
    int? tablets,
    String? time,
    bool? isTaken,
  }) {
    return PillModel(
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      tablets: tablets ?? this.tablets,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}

