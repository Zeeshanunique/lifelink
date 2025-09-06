import '../models/organ_donor.dart';
import '../repositories/organ_donor_repository.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import 'base_service.dart';

class OrganDonorService extends BaseServiceWithValidation<OrganDonor> {
  final OrganDonorRepository _repository;

  OrganDonorService(this._repository);

  @override
  Future<Result<List<OrganDonor>>> getAll() async {
    try {
      return await _repository.getAll();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch organ donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> getById(String id) async {
    try {
      return await _repository.getById(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> create(OrganDonor donor) async {
    try {
      final validationResult = await validate(donor);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.create(donor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to create organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> update(String id, OrganDonor donor) async {
    try {
      final validationResult = await validate(donor);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.update(id, donor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      return await _repository.delete(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> search(String query) async {
    try {
      return await _repository.search(query);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search organ donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool>> validate(OrganDonor donor) async {
    final errors = await getValidationErrors(donor);
    return Result.success(errors.data?.isEmpty ?? true);
  }

  @override
  Future<Result<List<String>>> getValidationErrors(OrganDonor donor) async {
    final errors = <String>[];

    if (donor.firstName.trim().isEmpty) {
      errors.add('First name is required');
    }

    if (donor.lastName.trim().isEmpty) {
      errors.add('Last name is required');
    }

    if (donor.dateOfBirth.isAfter(DateTime.now())) {
      errors.add('Date of birth cannot be in the future');
    }

    if (donor.age < 18) {
      errors.add('Donor must be at least 18 years old');
    }

    if (donor.bloodType.trim().isEmpty) {
      errors.add('Blood type is required');
    }

    if (donor.organsToDonate.isEmpty) {
      errors.add('At least one organ must be selected for donation');
    }

    if (donor.address.trim().isEmpty) {
      errors.add('Address is required');
    }

    if (donor.city.trim().isEmpty) {
      errors.add('City is required');
    }

    if (donor.state.trim().isEmpty) {
      errors.add('State is required');
    }

    if (donor.country.trim().isEmpty) {
      errors.add('Country is required');
    }

    return Result.success(errors);
  }

  // Organ donor-specific methods
  Future<Result<List<OrganDonor>>> getActiveDonors() async {
    try {
      return await _repository.getActiveDonors();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch active donors: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<OrganDonor>>> getByBloodType(String bloodType) async {
    try {
      return await _repository.getByBloodType(bloodType);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by blood type: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<OrganDonor>>> getByOrganType(String organType) async {
    try {
      return await _repository.getByOrganType(organType);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by organ type: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<OrganDonor>>> getCompatibleDonors(
    String recipientId,
  ) async {
    try {
      return await _repository.getCompatibleDonors(recipientId);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch compatible donors: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<OrganDonor>>> getAvailableDonors() async {
    try {
      return await _repository.getAvailableDonors();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch available donors: ${e.toString()}'),
      );
    }
  }

  Future<Result<bool>> isCompatible(
    String donorId,
    String recipientId,
    String organType,
  ) async {
    try {
      return await _repository.isCompatible(donorId, recipientId, organType);
    } catch (e) {
      return Result.failure(
        OrganMatchingFailure('Failed to check compatibility: ${e.toString()}'),
      );
    }
  }

  Future<Result<Map<String, dynamic>>> getOrganMatchingData(
    String donorId,
    String recipientId,
  ) async {
    try {
      return await _repository.getOrganMatchingData(donorId, recipientId);
    } catch (e) {
      return Result.failure(
        OrganMatchingFailure('Failed to get matching data: ${e.toString()}'),
      );
    }
  }

  Future<Result<OrganDonor>> registerAsDonor(OrganDonor donor) async {
    try {
      final validationResult = await validate(donor);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      final donorWithRegistration = donor.copyWith(
        registrationDate: DateTime.now(),
        lastUpdated: DateTime.now(),
        status: 'Registered',
      );

      return await _repository.create(donorWithRegistration);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to register as donor: ${e.toString()}'),
      );
    }
  }

  Future<Result<OrganDonor>> updateDonorStatus(
    String donorId,
    String status,
  ) async {
    try {
      final donorResult = await _repository.getById(donorId);
      if (donorResult.isFailure) {
        return Result.failure(donorResult.failure!);
      }

      final updatedDonor = donorResult.data!.copyWith(
        status: status,
        lastUpdated: DateTime.now(),
      );

      return await _repository.update(donorId, updatedDonor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update donor status: ${e.toString()}'),
      );
    }
  }

  Future<Result<OrganDonor>> markAsDeceased(
    String donorId,
    String causeOfDeath,
  ) async {
    try {
      final donorResult = await _repository.getById(donorId);
      if (donorResult.isFailure) {
        return Result.failure(donorResult.failure!);
      }

      final updatedDonor = donorResult.data!.copyWith(
        isDeceased: true,
        deathDate: DateTime.now(),
        causeOfDeath: causeOfDeath,
        status: 'Deceased',
        lastUpdated: DateTime.now(),
      );

      return await _repository.update(donorId, updatedDonor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to mark donor as deceased: ${e.toString()}'),
      );
    }
  }

  Future<Result<OrganDonor>> markAsTransplanted(
    String donorId,
    String transplantHospitalId,
  ) async {
    try {
      final donorResult = await _repository.getById(donorId);
      if (donorResult.isFailure) {
        return Result.failure(donorResult.failure!);
      }

      final updatedDonor = donorResult.data!.copyWith(
        isTransplanted: true,
        transplantDate: DateTime.now(),
        transplantHospitalId: transplantHospitalId,
        status: 'Transplanted',
        lastUpdated: DateTime.now(),
      );

      return await _repository.update(donorId, updatedDonor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to mark donor as transplanted: ${e.toString()}'),
      );
    }
  }

  Future<Result<Map<String, int>>> getDonorStatistics(String hospitalId) async {
    try {
      return await _repository.getDonorStatistics(hospitalId);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donor statistics: ${e.toString()}'),
      );
    }
  }
}
