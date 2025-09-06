import '../models/hospital.dart';
import '../utils/result.dart';
import 'base_repository.dart';

abstract class HospitalRepository
    extends BaseRepositoryWithPagination<Hospital> {
  Future<Result<List<Hospital>>> getByType(String type);
  Future<Result<List<Hospital>>> getBySpecialty(String specialty);
  Future<Result<List<Hospital>>> getByLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
  });
  Future<Result<List<Hospital>>> getWithOrganTransplantCapability();
  Future<Result<List<Hospital>>> getByCity(String city);
  Future<Result<List<Hospital>>> getByState(String state);
  Future<Result<Hospital>> getByLicenseNumber(String licenseNumber);
  Future<Result<List<Hospital>>> getActiveHospitals();
  Future<Result<List<Hospital>>> getHospitalsByUserRole(
    String userId,
    String role,
  );
  Future<Result<Map<String, int>>> getHospitalStatistics(String hospitalId);
  Future<Result<List<String>>> getAvailableSpecialties();
  Future<Result<List<String>>> getAvailableServices();
}
