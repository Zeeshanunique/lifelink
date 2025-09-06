import '../models/organ_donor.dart';
import '../utils/result.dart';
import 'base_repository.dart';

abstract class OrganDonorRepository
    extends BaseRepositoryWithPagination<OrganDonor> {
  @override
  Future<Result<List<OrganDonor>>> getByHospitalId(String hospitalId);
  Future<Result<List<OrganDonor>>> getByStatus(String status);
  Future<Result<List<OrganDonor>>> getByBloodType(String bloodType);
  Future<Result<List<OrganDonor>>> getByOrganType(String organType);
  Future<Result<List<OrganDonor>>> getActiveDonors();
  Future<Result<List<OrganDonor>>> getDeceasedDonors();
  Future<Result<List<OrganDonor>>> getTransplantedDonors();
  Future<Result<List<OrganDonor>>> getByAgeRange(int minAge, int maxAge);
  Future<Result<List<OrganDonor>>> getByGender(String gender);
  Future<Result<List<OrganDonor>>> getByCity(String city);
  Future<Result<List<OrganDonor>>> getByState(String state);
  Future<Result<List<OrganDonor>>> getCompatibleDonors(String recipientId);
  Future<Result<List<OrganDonor>>> getAvailableDonors();
  Future<Result<List<OrganDonor>>> getDonorsByHealthStatus(String healthStatus);
  Future<Result<List<OrganDonor>>> getDonorsByRegistrationDate(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<List<OrganDonor>>> getDonorsByTransplantDate(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<Map<String, int>>> getDonorStatistics(String hospitalId);
  Future<Result<List<String>>> getAvailableOrgans();
  Future<Result<List<OrganDonor>>> searchByName(String name);
  Future<Result<List<OrganDonor>>> getDonorsByOrganCompatibility(
    String organType,
    String bloodType,
  );
  Future<Result<OrganDonor>> getByPatientId(String patientId);
  Future<Result<List<OrganDonor>>> getDonorsByMatchingRecipient(
    String recipientId,
  );
  Future<Result<Map<String, dynamic>>> getOrganMatchingData(
    String donorId,
    String recipientId,
  );
  Future<Result<bool>> isCompatible(
    String donorId,
    String recipientId,
    String organType,
  );
}
