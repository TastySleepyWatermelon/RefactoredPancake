import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/activity_feed_item.dart';
import '../models/appointment.dart';
import '../models/care_schedule_item.dart';
import '../models/caregiver.dart';
import '../models/medication.dart';
import '../models/patient.dart';
import '../models/shift.dart';
import '../models/task.dart';

/// Talks to the Supabase Postgres tables backing the app's data.
///
/// The Supabase project is configured in `.env` (see `.env.example`) and
/// initialized via `Supabase.initialize` in `main.dart` before this service
/// is used.
class DatabaseService {
  DatabaseService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  // ---------------------------------------------------------------------
  // Patients
  // ---------------------------------------------------------------------

  Future<List<Patient>> getPatients() async {
    final rows = await _client.from('patients').select();
    return rows.map(Patient.fromJson).toList();
  }

  Future<Patient> getPatient(String id) async {
    final row =
        await _client.from('patients').select().eq('id', id).single();
    return Patient.fromJson(row);
  }

  Future<Patient> createPatient(Patient patient) async {
    final data = patient.toJson()..remove('id');
    final row =
        await _client.from('patients').insert(data).select().single();
    return Patient.fromJson(row);
  }

  Future<Patient> updatePatient(String id, Patient patient) async {
    final row = await _client
        .from('patients')
        .update(patient.toJson())
        .eq('id', id)
        .select()
        .single();
    return Patient.fromJson(row);
  }

  Future<void> deletePatient(String id) async {
    await _client.from('patients').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Caregivers
  // ---------------------------------------------------------------------

  Future<List<Caregiver>> getCaregivers() async {
    final rows = await _client.from('caregivers').select();
    return rows.map(Caregiver.fromJson).toList();
  }

  Future<Caregiver> getCaregiver(String id) async {
    final row =
        await _client.from('caregivers').select().eq('id', id).single();
    return Caregiver.fromJson(row);
  }

  Future<Caregiver> createCaregiver(Caregiver caregiver) async {
    final data = caregiver.toJson()..remove('id');
    final row =
        await _client.from('caregivers').insert(data).select().single();
    return Caregiver.fromJson(row);
  }

  Future<Caregiver> updateCaregiver(String id, Caregiver caregiver) async {
    final row = await _client
        .from('caregivers')
        .update(caregiver.toJson())
        .eq('id', id)
        .select()
        .single();
    return Caregiver.fromJson(row);
  }

  Future<void> deleteCaregiver(String id) async {
    await _client.from('caregivers').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Medications
  // ---------------------------------------------------------------------

  Future<List<Medication>> getMedications() async {
    final rows = await _client.from('medications').select();
    return rows.map(Medication.fromJson).toList();
  }

  Future<Medication> getMedicationById(String id) async {
    final row =
        await _client.from('medications').select().eq('id', id).single();
    return Medication.fromJson(row);
  }

  Future<Medication> createMedication(Medication medication) async {
    final data = medication.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');
    final row =
        await _client.from('medications').insert(data).select().single();
    return Medication.fromJson(row);
  }

  Future<Medication> updateMedication(String id, Medication medication) async {
    final data = medication.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');
    final row = await _client
        .from('medications')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return Medication.fromJson(row);
  }

  Future<void> deleteMedication(String id) async {
    await _client.from('medications').delete().eq('id', id);
  }

  Future<void> markMedicationTaken(String id, String confirmedBy) async {
    await _client.from('medications').update({
      'status': 'taken',
      'confirmed_by': confirmedBy,
    }).eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Tasks
  // ---------------------------------------------------------------------

  Future<List<Task>> getTasks() async {
    final rows = await _client.from('tasks').select();
    return rows.map(Task.fromJson).toList();
  }

  Future<Task> getTaskById(String id) async {
    final row = await _client.from('tasks').select().eq('id', id).single();
    return Task.fromJson(row);
  }

  Future<void> addTask(Task task) async {
    final data = task.toJson()..remove('id');
    await _client.from('tasks').insert(data);
  }

  Future<void> updateTaskStatus(String id, String status) async {
    await _client.from('tasks').update({'status': status}).eq('id', id);
  }

  Future<Task> createTask(Task task) async {
    final data = task.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');
    final row = await _client.from('tasks').insert(data).select().single();
    return Task.fromJson(row);
  }

  Future<Task> updateTask(String id, Task task) async {
    final data = task.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('updated_at');
    final row = await _client
        .from('tasks')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return Task.fromJson(row);
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Appointments
  // ---------------------------------------------------------------------

  Future<List<Appointment>> getAppointments({String? patientId}) async {
    final query = _client.from('appointments').select();
    final rows = await (patientId == null
        ? query
        : query.eq('patient_id', patientId));
    return rows.map(Appointment.fromJson).toList();
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    final data = appointment.toJson()..remove('id');
    final row =
        await _client.from('appointments').insert(data).select().single();
    return Appointment.fromJson(row);
  }

  Future<Appointment> updateAppointment(
      String id, Appointment appointment) async {
    final row = await _client
        .from('appointments')
        .update(appointment.toJson())
        .eq('id', id)
        .select()
        .single();
    return Appointment.fromJson(row);
  }

  Future<void> deleteAppointment(String id) async {
    await _client.from('appointments').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Shifts
  // ---------------------------------------------------------------------

  Future<List<Shift>> getShifts({String? caregiverId}) async {
    final query = _client.from('shifts').select();
    final rows = await (caregiverId == null
        ? query
        : query.eq('caregiver_id', caregiverId));
    return rows.map(Shift.fromJson).toList();
  }

  Future<Shift> createShift(Shift shift) async {
    final data = shift.toJson()..remove('id');
    final row = await _client.from('shifts').insert(data).select().single();
    return Shift.fromJson(row);
  }

  Future<Shift> updateShift(String id, Shift shift) async {
    final row = await _client
        .from('shifts')
        .update(shift.toJson())
        .eq('id', id)
        .select()
        .single();
    return Shift.fromJson(row);
  }

  Future<void> deleteShift(String id) async {
    await _client.from('shifts').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Care schedule
  // ---------------------------------------------------------------------

  Future<List<CareScheduleItem>> getCareSchedule({String? patientId}) async {
    final query = _client.from('care_schedule_items').select();
    final rows = await (patientId == null
        ? query
        : query.eq('patient_id', patientId));
    return rows.map(CareScheduleItem.fromJson).toList();
  }

  Future<CareScheduleItem> createCareScheduleItem(
      CareScheduleItem item) async {
    final data = item.toJson()..remove('id');
    final row = await _client
        .from('care_schedule_items')
        .insert(data)
        .select()
        .single();
    return CareScheduleItem.fromJson(row);
  }

  Future<CareScheduleItem> updateCareScheduleItem(
      String id, CareScheduleItem item) async {
    final row = await _client
        .from('care_schedule_items')
        .update(item.toJson())
        .eq('id', id)
        .select()
        .single();
    return CareScheduleItem.fromJson(row);
  }

  Future<void> deleteCareScheduleItem(String id) async {
    await _client.from('care_schedule_items').delete().eq('id', id);
  }

  // ---------------------------------------------------------------------
  // Activity feed
  // ---------------------------------------------------------------------

  Future<List<ActivityFeedItem>> getActivityFeed({int? limit}) async {
    final query =
        _client.from('activity_feed_items').select().order('date').order('time');
    final rows = await (limit == null ? query : query.limit(limit));
    return rows.map(ActivityFeedItem.fromJson).toList();
  }

  Future<ActivityFeedItem> createActivityFeedItem(
      ActivityFeedItem item) async {
    final data = item.toJson()..remove('id');
    final row = await _client
        .from('activity_feed_items')
        .insert(data)
        .select()
        .single();
    return ActivityFeedItem.fromJson(row);
  }
}
