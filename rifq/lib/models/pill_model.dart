class PillModel {
  final String pillName;
  final String dosage;
  final int tablets;
  final String time;
  final bool isTaken;
  final String markedByName;

  const PillModel({
    required this.pillName,
    required this.dosage,
    required this.tablets,
    required this.time,
    required this.isTaken,
    required this.markedByName,
  });

  PillModel copyWith({
    String? pillName,
    String? dosage,
    int? tablets,
    String? time,
    bool? isTaken,
    String? markedByName,
  }) {
    return PillModel(
      pillName: pillName ?? this.pillName,
      dosage: dosage ?? this.dosage,
      tablets: tablets ?? this.tablets,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
      markedByName: markedByName ?? this.markedByName,
    );
  }
}

