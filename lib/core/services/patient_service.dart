import '../models/patient.dart';
import '../repositories/patient_repository.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import 'base_service.dart';

class PatientService extends BaseServiceWithValidation<Patient> {
  final PatientRepository _repository;

  PatientService(this._repository);

  @override
  Future<Result<List<Patient>>> getAll() async {
    try {
      return await _repository.getAll();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch patients: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Patient>> getById(String id) async {
    try {
      return await _repository.getById(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch patient: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Patient>> create(Patient patient) async {
    try {
      final validationResult = await validate(patient);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.create(patient);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to create patient: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Patient>> update(String id, Patient patient) async {
    try {
      final validationResult = await validate(patient);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.update(id, patient);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update patient: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      return await _repository.delete(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete patient: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Patient>>> search(String query) async {
    try {
      return await _repository.search(query);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search patients: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool>> validate(Patient patient) async {
    final errors = await getValidationErrors(patient);
    return Result.success(errors.data?.isEmpty ?? true);
  }

  @override
  Future<Result<List<String>>> getValidationErrors(Patient patient) async {
    final errors = <String>[];

    if (patient.firstName.trim().isEmpty) {
      errors.add('First name is required');
    }

    if (patient.lastName.trim().isEmpty) {
      errors.add('Last name is required');
    }

    if (patient.dateOfBirth.isAfter(DateTime.now())) {
      errors.add('Date of birth cannot be in the future');
    }

    if (patient.bloodType.trim().isEmpty) {
      errors.add('Blood type is required');
    }

    if (patient.address.trim().isEmpty) {
      errors.add('Address is required');
    }

    if (patient.city.trim().isEmpty) {
      errors.add('City is required');
    }

    if (patient.state.trim().isEmpty) {
      errors.add('State is required');
    }

    if (patient.country.trim().isEmpty) {
      errors.add('Country is required');
    }

    return Result.success(errors);
  }

  // Patient-specific methods
  Future<Result<List<Patient>>> getByHospitalId(String hospitalId) async {
    try {
      return await _repository.getByHospitalId(hospitalId);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch patients by hospital: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Patient>>> getByDoctorId(String doctorId) async {
    try {
      return await _repository.getByDoctorId(doctorId);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch patients by doctor: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Patient>>> getByStatus(String status) async {
    try {
      return await _repository.getByStatus(status);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch patients by status: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Patient>>> getByBloodType(String bloodType) async {
    try {
      return await _repository.getByBloodType(bloodType);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch patients by blood type: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Patient>>> getEmergencyPatients() async {
    try {
      return await _repository.getEmergencyPatients();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch emergency patients: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Patient>>> getActivePatients() async {
    try {
      return await _repository.getActivePatients();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch active patients: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Patient>>> getOrganDonors() async {
    try {
      return await _repository.getOrganDonors();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch organ donors: ${e.toString()}'),
      );
    }
  }

  Future<Result<Map<String, int>>> getPatientStatistics(
    String hospitalId,
  ) async {
    try {
      return await _repository.getPatientStatistics(hospitalId);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch patient statistics: ${e.toString()}'),
      );
    }
  }

  // Additional methods needed by providers
  Future<Result<List<Patient>>> searchPatients(String query) async {
    return search(query);
  }

  Future<Result<List<Patient>>> getPatientsByStatus(String status) async {
    return getByStatus(status);
  }

  Future<Result<List<Patient>>> getRecentPatients() async {
    try {
      return await _repository.getRecentPatients();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch recent patients: ${e.toString()}'),
      );
    }
  }
}
