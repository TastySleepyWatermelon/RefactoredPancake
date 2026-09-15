class PillModel {
  final String pillName;
  final String dosage;
  final int tablets;
  final String time;
  final bool isTaken;

  const PillModel({
    required this.pillName,
    required this.dosage,
    required this.tablets,
    required this.time,
    this.isTaken = false,
  });

  PillModel copyWith({
    String? pillName,
    String? dosage,
    int? tablets,
    String? time,
    bool? isTaken,
  }) {
    return PillModel(
      pillName: pillName ?? this.pillName,
      dosage: dosage ?? this.dosage,
      tablets: tablets ?? this.tablets,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}

