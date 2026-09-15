class VisitModel {
  final String visitName;
  final String doctorName;
  final String day;
  final String month;
  final String time;
  final bool isHandled;
  final String markedByName;

  const VisitModel({
    required this.visitName,
    required this.doctorName,
    required this.day,
    required this.month,
    required this.time,
    required this.isHandled,
    required this.markedByName,
  });

  VisitModel copyWith({
    String? visitName,
    String? doctorName,
    String? day,
    String? month,
    String? time,
    bool? isHandled,
    String? markedByName,
  }) {
    return VisitModel(
      visitName: visitName ?? this.visitName,
      doctorName: doctorName ?? this.doctorName,
      day: day ?? this.day,
      month: month ?? this.month,
      time: time ?? this.time,
      isHandled: isHandled ?? this.isHandled,
      markedByName: markedByName ?? this.markedByName,
    );
  }
}

