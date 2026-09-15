import 'package:rifq/models/pill_model.dart';

class PillService {
  final List<PillModel> _pills = [
    const PillModel(
      pillName: 'Lisinopril',
      dosage: '10mg',
      tablets: 1,
      time: '8:00 AM',
      isTaken: true,
      markedByName: 'Sarah',
    ),
    const PillModel(
      pillName: 'Metformin',
      dosage: '500mg',
      tablets: 2,
      time: '8:00 AM',
      isTaken: true,
      markedByName: 'Sarah',
    ),
    const PillModel(
      pillName: 'Atorvastatin',
      dosage: '20mg',
      tablets: 1,
      time: '9:00 PM',
      isTaken: false,
      markedByName: 'Emily',
    ),
    const PillModel(
      pillName: 'Omeprazole',
      dosage: '20mg',
      tablets: 1,
      time: '7:30 AM',
      isTaken: false,
      markedByName: 'Emily',
    ),
    const PillModel(
      pillName: 'Amlodipine',
      dosage: '5mg',
      tablets: 1,
      time: '8:00 AM',
      isTaken: true,
      markedByName: 'Sarah',
    ),
    const PillModel(
      pillName: 'Vitamin D3',
      dosage: '1000 IU',
      tablets: 1,
      time: '12:00 PM',
      isTaken: false,
      markedByName: 'Emily',
    ),
  ];

  List<PillModel> getPills() {
    return List.unmodifiable(_pills);
  }

  void addPill(PillModel pill) {
    _pills.add(pill);
  }
}

