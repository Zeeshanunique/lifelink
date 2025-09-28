import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';
import '../di/service_locator.dart';

// Appointment Service Provider
final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return getIt<AppointmentService>();
});

// All Appointments Provider
final appointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getAll();
  return result.when(
    success: (appointments) => appointments,
    failure: (failure) => <Appointment>[],
  );
});

// Appointments by Hospital Provider
final appointmentsByHospitalProvider =
    FutureProvider.family<List<Appointment>, String>((ref, hospitalId) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.getByHospitalId(hospitalId);
      return result.when(
        success: (appointments) => appointments,
        failure: (failure) => <Appointment>[],
      );
    });

// Appointments by Doctor Provider
final appointmentsByDoctorProvider =
    FutureProvider.family<List<Appointment>, String>((ref, doctorId) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.getByDoctorId(doctorId);
      return result.when(
        success: (appointments) => appointments,
        failure: (failure) => <Appointment>[],
      );
    });

// Appointments by Patient Provider
final appointmentsByPatientProvider =
    FutureProvider.family<List<Appointment>, String>((ref, patientId) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.getByPatientId(patientId);
      return result.when(
        success: (appointments) => appointments,
        failure: (failure) => <Appointment>[],
      );
    });

// Appointments by Status Provider
final appointmentsByStatusProvider =
    FutureProvider.family<List<Appointment>, String>((ref, status) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.getByStatus(status);
      return result.when(
        success: (appointments) => appointments,
        failure: (failure) => <Appointment>[],
      );
    });

// Today's Appointments Provider
final todaysAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final service = ref.watch(appointmentServiceProvider);
  final result = await service.getTodaysAppointments();
  return result.when(
    success: (appointments) => appointments,
    failure: (failure) => <Appointment>[],
  );
});

// Upcoming Appointments Provider
final upcomingAppointmentsProvider =
    FutureProvider.family<List<Appointment>, int>((ref, limit) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.getUpcomingAppointments();
      return result.when(
        success: (appointments) => appointments,
        failure: (failure) => <Appointment>[],
      );
    });

// Appointment Statistics Provider
final appointmentStatisticsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, hospitalId) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.getAppointmentStatistics(hospitalId);
      return result.when(
        success: (stats) => stats,
        failure: (failure) => <String, int>{},
      );
    });

// Search Appointments Provider
final searchAppointmentsProvider =
    FutureProvider.family<List<Appointment>, String>((ref, query) async {
      final service = ref.watch(appointmentServiceProvider);
      final result = await service.searchAppointments(query);
      return result.when(
        success: (appointments) => appointments,
        failure: (failure) => <Appointment>[],
      );
    });
