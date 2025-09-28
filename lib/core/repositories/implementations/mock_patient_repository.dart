import '../patient_repository.dart';
import '../../models/patient.dart';
import '../../utils/result.dart';
import '../../errors/failures.dart';

class MockPatientRepository implements PatientRepository {
  final List<Patient> _patients = [
    Patient(
      id: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      firstName: 'John',
      lastName: 'Doe',
      middleName: 'Michael',
      dateOfBirth: DateTime(1985, 5, 15),
      gender: 'Male',
      bloodType: 'O+',
      phoneNumber: '+1234567890',
      email: 'john.doe@email.com',
      address: '123 Main St',
      city: 'New York',
      state: 'NY',
      country: 'USA',
      zipCode: '10001',
      emergencyContactName: 'Jane Doe',
      emergencyContactPhone: '+1234567891',
      emergencyContactRelation: 'Spouse',
      medicalRecordNumber: 'MR001',
      insuranceProvider: 'Blue Cross',
      insuranceNumber: 'BC123456',
      status: 'Active',
      hospitalId: '1',
      assignedDoctorId: '1',
      assignedNurseId: '1',
      medicalHistory: {'diabetes': 'Type 2', 'hypertension': 'Controlled'},
      allergies: ['Penicillin', 'Shellfish'],
      medications: ['Metformin', 'Lisinopril'],
      vitalSigns: {'bp': '120/80', 'hr': '72', 'temp': '98.6'},
      notes: 'Regular checkup patient',
      isOrganDonor: true,
      donorRegistrationId: 'DONOR001',
    ),
    Patient(
      id: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      firstName: 'Sarah',
      lastName: 'Smith',
      dateOfBirth: DateTime(1990, 8, 22),
      gender: 'Female',
      bloodType: 'A+',
      phoneNumber: '+1234567892',
      email: 'sarah.smith@email.com',
      address: '456 Oak Ave',
      city: 'Los Angeles',
      state: 'CA',
      country: 'USA',
      zipCode: '90210',
      emergencyContactName: 'Bob Smith',
      emergencyContactPhone: '+1234567893',
      emergencyContactRelation: 'Brother',
      medicalRecordNumber: 'MR002',
      insuranceProvider: 'Aetna',
      insuranceNumber: 'AET789012',
      status: 'Active',
      hospitalId: '1',
      assignedDoctorId: '2',
      assignedNurseId: '2',
      medicalHistory: {'asthma': 'Mild'},
      allergies: ['Dust', 'Pollen'],
      medications: ['Albuterol'],
      vitalSigns: {'bp': '110/70', 'hr': '68', 'temp': '98.4'},
      notes: 'Asthma management',
      isOrganDonor: false,
    ),
    Patient(
      id: '3',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      firstName: 'Mike',
      lastName: 'Johnson',
      dateOfBirth: DateTime(1978, 12, 3),
      gender: 'Male',
      bloodType: 'B-',
      phoneNumber: '+1234567894',
      email: 'mike.johnson@email.com',
      address: '789 Pine St',
      city: 'Chicago',
      state: 'IL',
      country: 'USA',
      zipCode: '60601',
      emergencyContactName: 'Lisa Johnson',
      emergencyContactPhone: '+1234567895',
      emergencyContactRelation: 'Wife',
      medicalRecordNumber: 'MR003',
      insuranceProvider: 'Cigna',
      insuranceNumber: 'CIG345678',
      status: 'Critical',
      hospitalId: '2',
      assignedDoctorId: '3',
      assignedNurseId: '3',
      medicalHistory: {'heart_disease': 'Coronary artery disease'},
      allergies: ['Latex'],
      medications: ['Aspirin', 'Atorvastatin'],
      vitalSigns: {'bp': '140/90', 'hr': '85', 'temp': '99.1'},
      notes: 'Post-surgery recovery',
      isOrganDonor: true,
      donorRegistrationId: 'DONOR002',
    ),
  ];

  @override
  Future<Result<List<Patient>>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_patients);
  }

  @override
  Future<Result<Patient>> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final patient = _patients.firstWhere((p) => p.id == id);
      return Result.success(patient);
    } catch (e) {
      return Result.failure(NotFoundFailure('Patient not found'));
    }
  }

  @override
  Future<Result<Patient>> create(Patient patient) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _patients.add(patient);
    return Result.success(patient);
  }

  @override
  Future<Result<Patient>> update(String id, Patient patient) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final index = _patients.indexWhere((p) => p.id == id);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Patient not found'));
      }
      _patients[index] = patient;
      return Result.success(patient);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update patient: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final index = _patients.indexWhere((p) => p.id == id);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Patient not found'));
      }
      _patients.removeAt(index);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete patient: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Patient>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final results = _patients.where((patient) {
      final searchLower = query.toLowerCase();
      return patient.firstName.toLowerCase().contains(searchLower) ||
          patient.lastName.toLowerCase().contains(searchLower) ||
          patient.fullName.toLowerCase().contains(searchLower) ||
          (patient.email?.toLowerCase().contains(searchLower) ?? false) ||
          (patient.phoneNumber?.contains(query) ?? false) ||
          (patient.medicalRecordNumber?.toLowerCase().contains(searchLower) ??
              false);
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByHospitalId(String hospitalId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.hospitalId == hospitalId).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByDoctorId(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients
        .where((p) => p.assignedDoctorId == doctorId)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByNurseId(String nurseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients
        .where((p) => p.assignedNurseId == nurseId)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.status == status).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByBloodType(String bloodType) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.bloodType == bloodType).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByAgeRange(int minAge, int maxAge) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final results = _patients.where((p) {
      final age = now.difference(p.dateOfBirth).inDays ~/ 365;
      return age >= minAge && age <= maxAge;
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByGender(String gender) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.gender == gender).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByCity(String city) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.city == city).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByState(String state) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.state == state).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getEmergencyPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients
        .where((p) => p.status == 'Critical' || p.status == 'Emergency')
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getDischargedPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.status == 'Discharged').toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getActivePatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.status == 'Active').toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getOrganDonors() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) => p.isOrganDonor).toList();
    return Result.success(results);
  }

  @override
  Future<Result<Patient>> getByMedicalRecordNumber(
    String medicalRecordNumber,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final patient = _patients.firstWhere(
        (p) => p.medicalRecordNumber == medicalRecordNumber,
      );
      return Result.success(patient);
    } catch (e) {
      return Result.failure(NotFoundFailure('Patient not found'));
    }
  }

  @override
  Future<Result<List<Patient>>> searchByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final nameLower = name.toLowerCase();
    final results = _patients.where((p) {
      return p.firstName.toLowerCase().contains(nameLower) ||
          p.lastName.toLowerCase().contains(nameLower) ||
          p.fullName.toLowerCase().contains(nameLower);
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getPatientsWithAllergies(
    List<String> allergies,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) {
      if (p.allergies == null) return false;
      return allergies.any((allergy) => p.allergies!.contains(allergy));
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getPatientsByInsuranceProvider(
    String provider,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients
        .where((p) => p.insuranceProvider == provider)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<Map<String, int>>> getPatientStatistics(
    String hospitalId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final hospitalPatients = _patients
        .where((p) => p.hospitalId == hospitalId)
        .toList();

    final stats = <String, int>{
      'total': hospitalPatients.length,
      'active': hospitalPatients.where((p) => p.status == 'Active').length,
      'critical': hospitalPatients.where((p) => p.status == 'Critical').length,
      'discharged': hospitalPatients
          .where((p) => p.status == 'Discharged')
          .length,
      'organDonors': hospitalPatients.where((p) => p.isOrganDonor).length,
    };

    return Result.success(stats);
  }

  @override
  Future<Result<List<Patient>>> getPatientsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _patients.where((p) {
      return p.createdAt.isAfter(startDate) && p.createdAt.isBefore(endDate);
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getPatientsByDepartment(
    String department,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app, this would filter by department
    final results = _patients.take(5).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getRecentPatients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final results = _patients.where((p) {
      return now.difference(p.createdAt).inDays <= 7;
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app, this would filter by user ID
    final results = _patients.take(5).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Patient>>> getPaginated({
    int page = 0,
    int limit = 10,
    String? searchQuery,
    String? sortBy,
    bool ascending = true,
    Map<String, dynamic>? filters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, _patients.length);
    final results = _patients.sublist(startIndex, endIndex);
    return Result.success(results);
  }

  @override
  Future<Result<int>> getTotalCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Result.success(_patients.length);
  }
}
