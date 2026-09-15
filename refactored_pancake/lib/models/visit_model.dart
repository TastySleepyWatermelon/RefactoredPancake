class VisitModel {
  final String visitName;
  final String doctorName;
  final String day;
  final String month;
  final String time;
  final bool isHandled;

  const VisitModel({
    required this.visitName,
    required this.doctorName,
    required this.day,
    required this.month,
    required this.time,
    this.isHandled = false,
  });

  VisitModel copyWith({
    String? visitName,
    String? doctorName,
    String? day,
    String? month,
    String? time,
    bool? isHandled,
  }) {
    return VisitModel(
      visitName: visitName ?? this.visitName,
      doctorName: doctorName ?? this.doctorName,
      day: day ?? this.day,
      month: month ?? this.month,
      time: time ?? this.time,
      isHandled: isHandled ?? this.isHandled,
    );
  }
}

