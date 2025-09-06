import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hospital.dart';
import '../services/hospital_service.dart';
import '../repositories/hospital_repository.dart';
import '../di/service_locator.dart';

// Repository Provider
final hospitalRepositoryProvider = Provider<HospitalRepository>((ref) {
  return getIt<HospitalRepository>();
});

// Service Provider
final hospitalServiceProvider = Provider<HospitalService>((ref) {
  return getIt<HospitalService>();
});

// Data Providers
final hospitalsProvider = FutureProvider<List<Hospital>>((ref) async {
  final service = ref.watch(hospitalServiceProvider);
  final result = await service.getAll();

  return result.when(
    success: (hospitals) => hospitals,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final hospitalByIdProvider = FutureProvider.family<Hospital, String>((
  ref,
  id,
) async {
  final service = ref.watch(hospitalServiceProvider);
  final result = await service.getById(id);

  return result.when(
    success: (hospital) => hospital,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final hospitalsByTypeProvider = FutureProvider.family<List<Hospital>, String>((
  ref,
  type,
) async {
  final service = ref.watch(hospitalServiceProvider);
  final result = await service.getByType(type);

  return result.when(
    success: (hospitals) => hospitals,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final hospitalsBySpecialtyProvider =
    FutureProvider.family<List<Hospital>, String>((ref, specialty) async {
      final service = ref.watch(hospitalServiceProvider);
      final result = await service.getBySpecialty(specialty);

      return result.when(
        success: (hospitals) => hospitals,
        failure: (failure) =>
            throw Exception(failure.message ?? 'Unknown error'),
      );
    });

final hospitalsWithOrganTransplantProvider = FutureProvider<List<Hospital>>((
  ref,
) async {
  final service = ref.watch(hospitalServiceProvider);
  final result = await service.getWithOrganTransplantCapability();

  return result.when(
    success: (hospitals) => hospitals,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final activeHospitalsProvider = FutureProvider<List<Hospital>>((ref) async {
  final service = ref.watch(hospitalServiceProvider);
  final result = await service.getActiveHospitals();

  return result.when(
    success: (hospitals) => hospitals,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final hospitalStatisticsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, hospitalId) async {
      final service = ref.watch(hospitalServiceProvider);
      final result = await service.getHospitalStatistics(hospitalId);

      return result.when(
        success: (statistics) => statistics,
        failure: (failure) =>
            throw Exception(failure.message ?? 'Unknown error'),
      );
    });

// Search Provider
final hospitalSearchProvider = StateProvider<String>((ref) => '');

final filteredHospitalsProvider = Provider<AsyncValue<List<Hospital>>>((ref) {
  final searchQuery = ref.watch(hospitalSearchProvider);
  final hospitalsAsync = ref.watch(hospitalsProvider);

  return hospitalsAsync.when(
    data: (hospitals) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(hospitals);
      }

      final filtered = hospitals.where((hospital) {
        final query = searchQuery.toLowerCase();
        return hospital.name.toLowerCase().contains(query) ||
            hospital.city.toLowerCase().contains(query) ||
            hospital.state.toLowerCase().contains(query) ||
            hospital.type.toLowerCase().contains(query);
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
