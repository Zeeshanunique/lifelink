import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient.dart';
import '../services/patient_service.dart';
import '../di/service_locator.dart';

// Patient Service Provider
final patientServiceProvider = Provider<PatientService>((ref) {
  return getIt<PatientService>();
});

// All Patients Provider
final patientsProvider = FutureProvider<List<Patient>>((ref) async {
  final service = ref.watch(patientServiceProvider);
  final result = await service.getAll();
  return result.when(
    success: (patients) => patients,
    failure: (failure) => <Patient>[],
  );
});

// Active Patients Provider
final activePatientsProvider = FutureProvider<List<Patient>>((ref) async {
  final service = ref.watch(patientServiceProvider);
  final result = await service.getActivePatients();
  return result.when(
    success: (patients) => patients,
    failure: (failure) => <Patient>[],
  );
});

// Patients by Hospital Provider
final patientsByHospitalProvider = FutureProvider.family<List<Patient>, String>(
  (ref, hospitalId) async {
    final service = ref.watch(patientServiceProvider);
    final result = await service.getByHospitalId(hospitalId);
    return result.when(
      success: (patients) => patients,
      failure: (failure) => <Patient>[],
    );
  },
);

// Patient Statistics Provider
final patientStatisticsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, hospitalId) async {
      final service = ref.watch(patientServiceProvider);
      final result = await service.getPatientStatistics(hospitalId);
      return result.when(
        success: (stats) => stats,
        failure: (failure) => <String, int>{},
      );
    });

// Search Patients Provider
final searchPatientsProvider = FutureProvider.family<List<Patient>, String>((
  ref,
  query,
) async {
  final service = ref.watch(patientServiceProvider);
  final result = await service.searchPatients(query);
  return result.when(
    success: (patients) => patients,
    failure: (failure) => <Patient>[],
  );
});

// Patients by Status Provider
final patientsByStatusProvider = FutureProvider.family<List<Patient>, String>((
  ref,
  status,
) async {
  final service = ref.watch(patientServiceProvider);
  final result = await service.getPatientsByStatus(status);
  return result.when(
    success: (patients) => patients,
    failure: (failure) => <Patient>[],
  );
});

// Recent Patients Provider (for dashboard)
final recentPatientsProvider = FutureProvider.family<List<Patient>, int>((
  ref,
  limit,
) async {
  final service = ref.watch(patientServiceProvider);
  final result = await service.getRecentPatients();
  return result.when(
    success: (patients) => patients,
    failure: (failure) => <Patient>[],
  );
});
