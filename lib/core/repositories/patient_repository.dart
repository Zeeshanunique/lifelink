import '../models/patient.dart';
import '../utils/result.dart';
import 'base_repository.dart';

abstract class PatientRepository extends BaseRepositoryWithPagination<Patient> {
  @override
  Future<Result<List<Patient>>> getByHospitalId(String hospitalId);
  Future<Result<List<Patient>>> getByDoctorId(String doctorId);
  Future<Result<List<Patient>>> getByNurseId(String nurseId);
  Future<Result<List<Patient>>> getByStatus(String status);
  Future<Result<List<Patient>>> getByBloodType(String bloodType);
  Future<Result<List<Patient>>> getByAgeRange(int minAge, int maxAge);
  Future<Result<List<Patient>>> getByGender(String gender);
  Future<Result<List<Patient>>> getByCity(String city);
  Future<Result<List<Patient>>> getByState(String state);
  Future<Result<List<Patient>>> getEmergencyPatients();
  Future<Result<List<Patient>>> getDischargedPatients();
  Future<Result<List<Patient>>> getActivePatients();
  Future<Result<List<Patient>>> getOrganDonors();
  Future<Result<Patient>> getByMedicalRecordNumber(String medicalRecordNumber);
  Future<Result<List<Patient>>> searchByName(String name);
  Future<Result<List<Patient>>> getPatientsWithAllergies(
    List<String> allergies,
  );
  Future<Result<List<Patient>>> getPatientsByInsuranceProvider(String provider);
  Future<Result<Map<String, int>>> getPatientStatistics(String hospitalId);
  Future<Result<List<Patient>>> getPatientsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<List<Patient>>> getPatientsByDepartment(String department);
}
