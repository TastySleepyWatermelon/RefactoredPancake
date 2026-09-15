import 'package:refactored_pancake/models/pill_model.dart';

class PillService {
  final List<PillModel> _pills = [
    const PillModel(
      medicationName: 'Lisinopril',
      dosage: '10mg',
      tablets: 1,
      time: '8:00 AM',
      isTaken: true,
    ),
    const PillModel(
      medicationName: 'Metformin',
      dosage: '500mg',
      tablets: 2,
      time: '8:00 AM',
      isTaken: true,
    ),
    const PillModel(
      medicationName: 'Atorvastatin',
      dosage: '20mg',
      tablets: 1,
      time: '9:00 PM',
    ),
    const PillModel(
      medicationName: 'Omeprazole',
      dosage: '20mg',
      tablets: 1,
      time: '7:30 AM',
    ),
    const PillModel(
      medicationName: 'Amlodipine',
      dosage: '5mg',
      tablets: 1,
      time: '8:00 AM',
      isTaken: true,
    ),
    const PillModel(
      medicationName: 'Vitamin D3',
      dosage: '1000 IU',
      tablets: 1,
      time: '12:00 PM',
    ),
  ];

  List<PillModel> getPills() {
    return List.unmodifiable(_pills);
  }

  void addPill(PillModel pill) {
    _pills.add(pill);
  }
}

