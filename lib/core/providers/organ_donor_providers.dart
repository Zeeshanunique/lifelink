import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/organ_donor.dart';
import '../services/organ_donor_service.dart';
import '../repositories/organ_donor_repository.dart';
import '../di/service_locator.dart';

// Repository Provider
final organDonorRepositoryProvider = Provider<OrganDonorRepository>((ref) {
  return getIt<OrganDonorRepository>();
});

// Service Provider
final organDonorServiceProvider = Provider<OrganDonorService>((ref) {
  return getIt<OrganDonorService>();
});

// Data Providers
final organDonorsProvider = FutureProvider<List<OrganDonor>>((ref) async {
  final service = ref.watch(organDonorServiceProvider);
  final result = await service.getAll();

  return result.when(
    success: (donors) => donors,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final organDonorByIdProvider = FutureProvider.family<OrganDonor, String>((
  ref,
  id,
) async {
  final service = ref.watch(organDonorServiceProvider);
  final result = await service.getById(id);

  return result.when(
    success: (donor) => donor,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final activeDonorsProvider = FutureProvider<List<OrganDonor>>((ref) async {
  final service = ref.watch(organDonorServiceProvider);
  final result = await service.getActiveDonors();

  return result.when(
    success: (donors) => donors,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final donorsByBloodTypeProvider =
    FutureProvider.family<List<OrganDonor>, String>((ref, bloodType) async {
      final service = ref.watch(organDonorServiceProvider);
      final result = await service.getByBloodType(bloodType);

      return result.when(
        success: (donors) => donors,
        failure: (failure) =>
            throw Exception(failure.message ?? 'Unknown error'),
      );
    });

final donorsByOrganTypeProvider =
    FutureProvider.family<List<OrganDonor>, String>((ref, organType) async {
      final service = ref.watch(organDonorServiceProvider);
      final result = await service.getByOrganType(organType);

      return result.when(
        success: (donors) => donors,
        failure: (failure) =>
            throw Exception(failure.message ?? 'Unknown error'),
      );
    });

final compatibleDonorsProvider =
    FutureProvider.family<List<OrganDonor>, String>((ref, recipientId) async {
      final service = ref.watch(organDonorServiceProvider);
      final result = await service.getCompatibleDonors(recipientId);

      return result.when(
        success: (donors) => donors,
        failure: (failure) =>
            throw Exception(failure.message ?? 'Unknown error'),
      );
    });

final availableDonorsProvider = FutureProvider<List<OrganDonor>>((ref) async {
  final service = ref.watch(organDonorServiceProvider);
  final result = await service.getAvailableDonors();

  return result.when(
    success: (donors) => donors,
    failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
  );
});

final donorStatisticsProvider = FutureProvider.family<Map<String, int>, String>(
  (ref, hospitalId) async {
    final service = ref.watch(organDonorServiceProvider);
    final result = await service.getDonorStatistics(hospitalId);

    return result.when(
      success: (statistics) => statistics,
      failure: (failure) => throw Exception(failure.message ?? 'Unknown error'),
    );
  },
);

// Compatibility Check Provider
final organCompatibilityProvider =
    FutureProvider.family<bool, OrganCompatibilityParams>((ref, params) async {
      final service = ref.watch(organDonorServiceProvider);
      final result = await service.isCompatible(
        params.donorId,
        params.recipientId,
        params.organType,
      );

      return result.when(
        success: (isCompatible) => isCompatible,
        failure: (failure) =>
            throw Exception(failure.message ?? 'Unknown error'),
      );
    });

// Search Provider
final donorSearchProvider = StateProvider<String>((ref) => '');

final filteredDonorsProvider = Provider<AsyncValue<List<OrganDonor>>>((ref) {
  final searchQuery = ref.watch(donorSearchProvider);
  final donorsAsync = ref.watch(organDonorsProvider);

  return donorsAsync.when(
    data: (donors) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(donors);
      }

      final filtered = donors.where((donor) {
        final query = searchQuery.toLowerCase();
        return donor.firstName.toLowerCase().contains(query) ||
            donor.lastName.toLowerCase().contains(query) ||
            donor.city.toLowerCase().contains(query) ||
            donor.state.toLowerCase().contains(query) ||
            donor.bloodType.toLowerCase().contains(query);
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Filter Providers
final donorStatusFilterProvider = StateProvider<String>((ref) => 'All');
final donorBloodTypeFilterProvider = StateProvider<String>((ref) => 'All');
final donorOrganTypeFilterProvider = StateProvider<String>((ref) => 'All');
final donorActiveOnlyFilterProvider = StateProvider<bool>((ref) => false);

final filteredDonorsByStatusProvider = Provider<AsyncValue<List<OrganDonor>>>((
  ref,
) {
  final status = ref.watch(donorStatusFilterProvider);
  final bloodType = ref.watch(donorBloodTypeFilterProvider);
  final organType = ref.watch(donorOrganTypeFilterProvider);
  final activeOnly = ref.watch(donorActiveOnlyFilterProvider);
  final donorsAsync = ref.watch(organDonorsProvider);

  return donorsAsync.when(
    data: (donors) {
      final filtered = donors.where((donor) {
        if (status != 'All' && donor.status != status) return false;
        if (bloodType != 'All' && donor.bloodType != bloodType) return false;
        if (organType != 'All' && !donor.organsToDonate.contains(organType)) {
          return false;
        }
        if (activeOnly && !donor.isActive) return false;
        return true;
      }).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Class for compatibility parameters
class OrganCompatibilityParams {
  final String donorId;
  final String recipientId;
  final String organType;

  OrganCompatibilityParams({
    required this.donorId,
    required this.recipientId,
    required this.organType,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrganCompatibilityParams &&
        other.donorId == donorId &&
        other.recipientId == recipientId &&
        other.organType == organType;
  }

  @override
  int get hashCode => Object.hash(donorId, recipientId, organType);
}
