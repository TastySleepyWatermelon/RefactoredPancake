import 'package:refactored_pancake/models/visit_model.dart';

class VisitService {
  final List<VisitModel> _visits = [
    const VisitModel(
      visitName: 'Annual Checkup',
      doctorName: 'Dr. Sarah Johnson',
      day: '22',
      month: 'SEP',
      time: '10:00 AM',
      isHandled: true,
      markedByName: 'John',
    ),
    const VisitModel(
      visitName: 'Dental Cleaning',
      doctorName: 'Dr. Michael Chen',
      day: '28',
      month: 'SEP',
      time: '2:30 PM',
      isHandled: true,
      markedByName: 'Alice',
    ),
    const VisitModel(
      visitName: 'Eye Exam',
      doctorName: 'Dr. Emily Roberts',
      day: '05',
      month: 'OCT',
      time: '11:00 AM',
      isHandled: true,
      markedByName: 'Alice',
    ),
    const VisitModel(
      visitName: 'Cardiology Follow-up',
      doctorName: 'Dr. James Williams',
      day: '12',
      month: 'OCT',
      time: '9:00 AM',
      isHandled: true,
      markedByName: 'John',
    ),
    const VisitModel(
      visitName: 'Lab Work',
      doctorName: 'Dr. Sarah Johnson',
      day: '18',
      month: 'OCT',
      time: '7:30 AM',
      isHandled: true,
      markedByName: 'John',
    ),
  ];

  List<VisitModel> getVisits() {
    return List.unmodifiable(_visits);
  }

  void addVisit(VisitModel visit) {
    _visits.add(visit);
  }
}

