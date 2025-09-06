import '../models/hospital.dart';
import '../repositories/hospital_repository.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import 'base_service.dart';

class HospitalService extends BaseServiceWithValidation<Hospital> {
  final HospitalRepository _repository;

  HospitalService(this._repository);

  @override
  Future<Result<List<Hospital>>> getAll() async {
    try {
      return await _repository.getAll();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> getById(String id) async {
    try {
      return await _repository.getById(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> create(Hospital hospital) async {
    try {
      final validationResult = await validate(hospital);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.create(hospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to create hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> update(String id, Hospital hospital) async {
    try {
      final validationResult = await validate(hospital);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.update(id, hospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      return await _repository.delete(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> search(String query) async {
    try {
      return await _repository.search(query);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search hospitals: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool>> validate(Hospital hospital) async {
    final errors = await getValidationErrors(hospital);
    return Result.success(errors.data?.isEmpty ?? true);
  }

  @override
  Future<Result<List<String>>> getValidationErrors(Hospital hospital) async {
    final errors = <String>[];

    if (hospital.name.trim().isEmpty) {
      errors.add('Hospital name is required');
    }

    if (hospital.type.trim().isEmpty) {
      errors.add('Hospital type is required');
    }

    if (hospital.address.trim().isEmpty) {
      errors.add('Address is required');
    }

    if (hospital.city.trim().isEmpty) {
      errors.add('City is required');
    }

    if (hospital.state.trim().isEmpty) {
      errors.add('State is required');
    }

    if (hospital.country.trim().isEmpty) {
      errors.add('Country is required');
    }

    if (hospital.totalBeds <= 0) {
      errors.add('Total beds must be greater than 0');
    }

    if (hospital.icuBeds < 0) {
      errors.add('ICU beds cannot be negative');
    }

    if (hospital.emergencyBeds < 0) {
      errors.add('Emergency beds cannot be negative');
    }

    if (hospital.icuBeds + hospital.emergencyBeds > hospital.totalBeds) {
      errors.add('ICU and emergency beds cannot exceed total beds');
    }

    return Result.success(errors);
  }

  // Hospital-specific methods
  Future<Result<List<Hospital>>> getByType(String type) async {
    try {
      return await _repository.getByType(type);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by type: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Hospital>>> getBySpecialty(String specialty) async {
    try {
      return await _repository.getBySpecialty(specialty);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch hospitals by specialty: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Hospital>>> getByLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
  }) async {
    try {
      return await _repository.getByLocation(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by location: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Hospital>>> getWithOrganTransplantCapability() async {
    try {
      return await _repository.getWithOrganTransplantCapability();
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch hospitals with organ transplant capability: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Hospital>>> getActiveHospitals() async {
    try {
      return await _repository.getActiveHospitals();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch active hospitals: ${e.toString()}'),
      );
    }
  }

  Future<Result<Map<String, int>>> getHospitalStatistics(
    String hospitalId,
  ) async {
    try {
      return await _repository.getHospitalStatistics(hospitalId);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospital statistics: ${e.toString()}'),
      );
    }
  }
}
