import '../organ_donor_repository.dart';
import '../../models/organ_donor.dart';
import '../../utils/result.dart';
import '../../errors/failures.dart';

class MockOrganDonorRepository implements OrganDonorRepository {
  // Mock data for demonstration
  final List<OrganDonor> _donors = [
    OrganDonor(
      id: '1',
      patientId: 'patient_001',
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1985, 5, 15),
      gender: 'Male',
      bloodType: 'O+',
      address: '123 Oak Street',
      city: 'New York',
      state: 'NY',
      country: 'USA',
      phoneNumber: '+1-555-0101',
      email: 'john.doe@email.com',
      emergencyContactName: 'Jane Doe',
      emergencyContactPhone: '+1-555-0102',
      emergencyContactRelation: 'Spouse',
      status: 'Active',
      hospitalId: '1',
      organsToDonate: ['Heart', 'Liver', 'Kidneys'],
      organsDonated: [],
      medicalHistory: {'diabetes': false, 'hypertension': false},
      allergies: ['Penicillin'],
      medications: ['Multivitamin'],
      healthStatus: 'Excellent',
      registrationDate: DateTime.now().subtract(const Duration(days: 30)),
      isDeceased: false,
      isTransplanted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    OrganDonor(
      id: '2',
      patientId: 'patient_002',
      firstName: 'Sarah',
      lastName: 'Johnson',
      dateOfBirth: DateTime(1990, 8, 22),
      gender: 'Female',
      bloodType: 'A+',
      address: '456 Pine Avenue',
      city: 'Los Angeles',
      state: 'CA',
      country: 'USA',
      phoneNumber: '+1-555-0201',
      email: 'sarah.johnson@email.com',
      emergencyContactName: 'Mike Johnson',
      emergencyContactPhone: '+1-555-0202',
      emergencyContactRelation: 'Brother',
      status: 'Active',
      hospitalId: '2',
      organsToDonate: ['Kidneys', 'Pancreas'],
      organsDonated: [],
      medicalHistory: {'diabetes': false, 'hypertension': false},
      allergies: [],
      medications: [],
      healthStatus: 'Good',
      registrationDate: DateTime.now().subtract(const Duration(days: 15)),
      isDeceased: false,
      isTransplanted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
    OrganDonor(
      id: '3',
      patientId: 'patient_003',
      firstName: 'Robert',
      lastName: 'Smith',
      dateOfBirth: DateTime(1978, 12, 10),
      gender: 'Male',
      bloodType: 'B+',
      address: '789 Elm Street',
      city: 'Chicago',
      state: 'IL',
      country: 'USA',
      phoneNumber: '+1-555-0301',
      email: 'robert.smith@email.com',
      emergencyContactName: 'Lisa Smith',
      emergencyContactPhone: '+1-555-0302',
      emergencyContactRelation: 'Wife',
      status: 'Transplanted',
      hospitalId: '1',
      organsToDonate: ['Heart', 'Lungs', 'Liver'],
      organsDonated: ['Heart', 'Liver'],
      medicalHistory: {'diabetes': false, 'hypertension': true},
      allergies: [],
      medications: ['Blood pressure medication'],
      healthStatus: 'Good',
      registrationDate: DateTime.now().subtract(const Duration(days: 7)),
      isDeceased: true,
      causeOfDeath: 'Car Accident',
      isTransplanted: true,
      transplantDate: DateTime.now().subtract(const Duration(days: 2)),
      transplantHospitalId: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<Result<List<OrganDonor>>> getAll() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(_donors);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch organ donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> getById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final donor = _donors.firstWhere(
        (d) => d.id == id,
        orElse: () => throw Exception('Organ donor not found'),
      );
      return Result.success(donor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> create(OrganDonor entity) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final newDonor = entity.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _donors.add(newDonor);
      return Result.success(newDonor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to create organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> update(String id, OrganDonor entity) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final index = _donors.indexWhere((d) => d.id == id);
      if (index == -1) {
        return Result.failure(ServerFailure('Organ donor not found'));
      }
      final updatedDonor = entity.copyWith(updatedAt: DateTime.now());
      _donors[index] = updatedDonor;
      return Result.success(updatedDonor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _donors.removeWhere((d) => d.id == id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete organ donor: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> search(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where(
            (donor) =>
                '${donor.firstName} ${donor.lastName}'.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                donor.city.toLowerCase().contains(query.toLowerCase()) ||
                donor.organsToDonate.any(
                  (organ) => organ.toLowerCase().contains(query.toLowerCase()),
                ),
          )
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search organ donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByHospitalId(String hospitalId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all donors for any hospital
      return Result.success(_donors);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByStatus(String status) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors.where((d) => d.status == status).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByBloodType(String bloodType) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors.where((d) => d.bloodType == bloodType).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by blood type: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByOrganType(String organType) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where((d) => d.organsToDonate.contains(organType))
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by organ type: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getActiveDonors() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where((d) => !d.isDeceased && !d.isTransplanted)
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch active donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getDeceasedDonors() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors.where((d) => d.isDeceased).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch deceased donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getTransplantedDonors() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors.where((d) => d.isTransplanted).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch transplanted donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByAgeRange(int minAge, int maxAge) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final now = DateTime.now();
      final filtered = _donors.where((d) {
        final age = now.year - d.dateOfBirth.year;
        return age >= minAge && age <= maxAge;
      }).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by age range: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByGender(String gender) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors.where((d) => d.gender == gender).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by gender: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByCity(String city) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where((d) => d.city.toLowerCase() == city.toLowerCase())
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by city: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByState(String state) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where((d) => d.state.toLowerCase() == state.toLowerCase())
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by state: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getCompatibleDonors(String recipientId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all available donors for any recipient
      final filtered = _donors
          .where((d) => !d.isDeceased && !d.isTransplanted)
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch compatible donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getAvailableDonors() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where((d) => !d.isDeceased && !d.isTransplanted)
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch available donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getDonorsByHealthStatus(
    String healthStatus,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where((d) => d.healthStatus == healthStatus)
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch donors by health status: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getDonorsByRegistrationDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where(
            (d) =>
                d.registrationDate != null &&
                d.registrationDate!.isAfter(startDate) &&
                d.registrationDate!.isBefore(endDate),
          )
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch donors by registration date: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getDonorsByTransplantDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where(
            (d) =>
                d.transplantDate != null &&
                d.transplantDate!.isAfter(startDate) &&
                d.transplantDate!.isBefore(endDate),
          )
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch donors by transplant date: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<Map<String, int>>> getDonorStatistics(String hospitalId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final hospitalDonors = _donors.where((d) => d.hospitalId == hospitalId).toList();
      final stats = {
        'totalDonors': hospitalDonors.length,
        'activeDonors': hospitalDonors
            .where((d) => !d.isDeceased && !d.isTransplanted)
            .length,
        'deceasedDonors': hospitalDonors.where((d) => d.isDeceased).length,
        'transplantedDonors': hospitalDonors.where((d) => d.isTransplanted).length,
        'averageAge': hospitalDonors.isNotEmpty
            ? hospitalDonors.fold(
                    0,
                    (sum, d) =>
                        sum + (DateTime.now().year - d.dateOfBirth.year),
                  ) ~/
                  hospitalDonors.length
            : 0,
      };
      return Result.success(stats);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donor statistics: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<String>>> getAvailableOrgans() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final organs = _donors.expand((d) => d.organsToDonate).toSet().toList();
      return Result.success(organs);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch available organs: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> searchByName(String name) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where(
            (d) => '${d.firstName} ${d.lastName}'.toLowerCase().contains(
              name.toLowerCase(),
            ),
          )
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search donors by name: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getDonorsByOrganCompatibility(
    String organType,
    String bloodType,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _donors
          .where(
            (d) =>
                d.organsToDonate.contains(organType) &&
                d.bloodType == bloodType &&
                !d.isDeceased &&
                !d.isTransplanted,
          )
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch donors by organ compatibility: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getDonorsByMatchingRecipient(
    String patientId,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all available donors for any patient
      final filtered = _donors
          .where((d) => !d.isDeceased && !d.isTransplanted)
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch donors by matching recipient: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getOrganMatchingData(
    String organType,
    String bloodType,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final compatibleDonors = _donors
          .where(
            (d) =>
                d.organsToDonate.contains(organType) &&
                d.bloodType == bloodType &&
                !d.isDeceased &&
                !d.isTransplanted,
          )
          .toList();

      final data = {
        'organType': organType,
        'bloodType': bloodType,
        'compatibleDonorsCount': compatibleDonors.length,
        'averageAge': compatibleDonors.isNotEmpty
            ? compatibleDonors.fold(
                    0,
                    (sum, d) =>
                        sum + (DateTime.now().year - d.dateOfBirth.year),
                  ) /
                  compatibleDonors.length
            : 0,
        'healthStatusDistribution': compatibleDonors.fold<Map<String, int>>(
          {},
          (map, d) {
            final status = d.healthStatus ?? 'Unknown';
            map[status] = (map[status] ?? 0) + 1;
            return map;
          },
        ),
      };
      return Result.success(data);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch organ matching data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool>> isCompatible(
    String donorId,
    String patientBloodType,
    String organType,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final donor = _donors.firstWhere((d) => d.id == donorId);
      final isCompatible =
          donor.bloodType == patientBloodType &&
          donor.organsToDonate.contains(organType) &&
          !donor.isDeceased &&
          !donor.isTransplanted;
      return Result.success(isCompatible);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to check compatibility: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getPaginated({
    int page = 0,
    int limit = 10,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      var filteredDonors = _donors;
      
      // Apply search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredDonors = filteredDonors.where((d) =>
            '${d.firstName} ${d.lastName}'.toLowerCase().contains(searchQuery.toLowerCase()) ||
            d.city.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }
      
      // Apply sorting
      if (sortBy != null) {
        filteredDonors.sort((a, b) {
          int comparison = 0;
          switch (sortBy) {
            case 'firstName':
              comparison = a.firstName.compareTo(b.firstName);
              break;
            case 'lastName':
              comparison = a.lastName.compareTo(b.lastName);
              break;
            case 'city':
              comparison = a.city.compareTo(b.city);
              break;
            case 'bloodType':
              comparison = a.bloodType.compareTo(b.bloodType);
              break;
            default:
              comparison = 0;
          }
          return ascending ? comparison : -comparison;
        });
      }
      
      // Apply pagination
      final startIndex = page * limit;
      final endIndex = (startIndex + limit).clamp(0, filteredDonors.length);
      final paginatedDonors = filteredDonors.sublist(startIndex, endIndex);
      return Result.success(paginatedDonors);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch paginated donors: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OrganDonor>>> getByUserId(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all donors for any user
      return Result.success(_donors);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donors by user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<OrganDonor>> getByPatientId(String patientId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final donor = _donors.firstWhere(
        (d) => d.patientId == patientId,
        orElse: () => throw Exception('Donor not found'),
      );
      return Result.success(donor);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch donor by patient: ${e.toString()}'),
      );
    }
  }
}
