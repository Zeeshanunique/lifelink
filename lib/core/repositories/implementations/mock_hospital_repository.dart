import '../hospital_repository.dart';
import '../../models/hospital.dart';
import '../../utils/result.dart';
import '../../errors/failures.dart';

class MockHospitalRepository implements HospitalRepository {
  // Mock data for demonstration
  final List<Hospital> _hospitals = [
    Hospital(
      id: '1',
      name: 'City General Hospital',
      type: 'General',
      address: '123 Main Street',
      city: 'New York',
      state: 'NY',
      country: 'USA',
      postalCode: '10001',
      phoneNumber: '+1-555-0123',
      email: 'info@citygeneral.com',
      website: 'https://citygeneral.com',
      latitude: 40.7128,
      longitude: -74.0060,
      totalBeds: 500,
      icuBeds: 50,
      emergencyBeds: 25,
      specialties: ['Cardiology', 'Neurology', 'Orthopedics'],
      services: ['Emergency', 'Surgery', 'ICU', 'Radiology'],
      isActive: true,
      licenseNumber: 'HOSP001',
      licenseExpiry: DateTime.now().add(const Duration(days: 365)),
      facilities: {'parking': true, 'cafeteria': true, 'pharmacy': true},
      organTransplantCapabilities: ['Heart', 'Liver', 'Kidney'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    Hospital(
      id: '2',
      name: 'Metro Medical Center',
      type: 'Specialty',
      address: '456 Oak Avenue',
      city: 'Los Angeles',
      state: 'CA',
      country: 'USA',
      postalCode: '90210',
      phoneNumber: '+1-555-0456',
      email: 'contact@metromedical.com',
      website: 'https://metromedical.com',
      latitude: 34.0522,
      longitude: -118.2437,
      totalBeds: 300,
      icuBeds: 30,
      emergencyBeds: 20,
      specialties: ['Oncology', 'Cardiology', 'Pediatrics'],
      services: ['Chemotherapy', 'Surgery', 'ICU', 'Laboratory'],
      isActive: true,
      licenseNumber: 'HOSP002',
      licenseExpiry: DateTime.now().add(const Duration(days: 200)),
      facilities: {'parking': true, 'cafeteria': false, 'pharmacy': true},
      organTransplantCapabilities: [],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
    Hospital(
      id: '3',
      name: 'Regional Heart Institute',
      type: 'Specialty',
      address: '789 Pine Street',
      city: 'Chicago',
      state: 'IL',
      country: 'USA',
      postalCode: '60601',
      phoneNumber: '+1-555-0789',
      email: 'info@regionalheart.com',
      website: 'https://regionalheart.com',
      latitude: 41.8781,
      longitude: -87.6298,
      totalBeds: 200,
      icuBeds: 25,
      emergencyBeds: 15,
      specialties: ['Cardiology', 'Cardiothoracic Surgery'],
      services: ['Heart Surgery', 'Cardiac ICU', 'Cath Lab', 'Rehabilitation'],
      isActive: true,
      licenseNumber: 'HOSP003',
      licenseExpiry: DateTime.now().add(const Duration(days: 500)),
      facilities: {'parking': true, 'cafeteria': true, 'pharmacy': true},
      organTransplantCapabilities: ['Heart', 'Lung'],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<Result<List<Hospital>>> getAll() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      return Result.success(_hospitals);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> getById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final hospital = _hospitals.firstWhere(
        (h) => h.id == id,
        orElse: () => throw Exception('Hospital not found'),
      );
      return Result.success(hospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> create(Hospital entity) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final newHospital = entity.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _hospitals.add(newHospital);
      return Result.success(newHospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to create hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> update(String id, Hospital entity) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final index = _hospitals.indexWhere((h) => h.id == id);
      if (index == -1) {
        return Result.failure(ServerFailure('Hospital not found'));
      }
      final updatedHospital = entity.copyWith(updatedAt: DateTime.now());
      _hospitals[index] = updatedHospital;
      return Result.success(updatedHospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _hospitals.removeWhere((h) => h.id == id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete hospital: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> search(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _hospitals
          .where(
            (hospital) =>
                hospital.name.toLowerCase().contains(query.toLowerCase()) ||
                hospital.city.toLowerCase().contains(query.toLowerCase()) ||
                hospital.specialties.any(
                  (specialty) =>
                      specialty.toLowerCase().contains(query.toLowerCase()),
                ),
          )
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search hospitals: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getByType(String type) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _hospitals.where((h) => h.type == type).toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by type: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getBySpecialty(String specialty) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _hospitals
          .where((h) => h.specialties.contains(specialty))
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch hospitals by specialty: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getByLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all hospitals for any location
      return Result.success(_hospitals);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by location: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getWithOrganTransplantCapability() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _hospitals
          .where((h) => h.hasOrganTransplantCapability)
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch hospitals with organ transplant capability: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getByCity(String city) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _hospitals
          .where((h) => h.city.toLowerCase() == city.toLowerCase())
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by city: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getByState(String state) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final filtered = _hospitals
          .where((h) => h.state.toLowerCase() == state.toLowerCase())
          .toList();
      return Result.success(filtered);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by state: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Hospital>> getByLicenseNumber(
    String licenseNumber,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final hospital = _hospitals.firstWhere(
        (h) => h.licenseNumber == licenseNumber,
        orElse: () => throw Exception('Hospital not found'),
      );
      return Result.success(hospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospital by license: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getActiveHospitals() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // All hospitals are considered active in this mock
      return Result.success(_hospitals);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch active hospitals: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getHospitalsByUserRole(
    String userId,
    String role,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all hospitals for any role
      return Result.success(_hospitals);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch hospitals by user role: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<Map<String, int>>> getHospitalStatistics(String hospitalId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final hospital = _hospitals.firstWhere((h) => h.id == hospitalId);
      final stats = {
        'totalBeds': hospital.totalBeds,
        'icuBeds': hospital.icuBeds,
        'emergencyBeds': hospital.emergencyBeds,
        'specialtiesCount': hospital.specialties.length,
        'servicesCount': hospital.services.length,
        'organTransplantCapabilitiesCount': hospital.organTransplantCapabilities?.length ?? 0,
      };
      return Result.success(stats);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospital statistics: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<String>>> getAvailableSpecialties() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final specialties = _hospitals
          .expand((h) => h.specialties)
          .toSet()
          .toList();
      return Result.success(specialties);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch available specialties: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<String>>> getAvailableServices() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final services = _hospitals.expand((h) => h.services).toSet().toList();
      return Result.success(services);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch available services: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getByHospitalId(String hospitalId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final hospital = _hospitals.where((h) => h.id == hospitalId).toList();
      return Result.success(hospital);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospital by ID: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getByUserId(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation - return all hospitals for any user
      return Result.success(_hospitals);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch hospitals by user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Hospital>>> getPaginated({
    int page = 0,
    int limit = 10,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      var filteredHospitals = _hospitals;
      
      // Apply search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredHospitals = filteredHospitals.where((h) =>
            h.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            h.city.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }
      
      // Apply sorting
      if (sortBy != null) {
        filteredHospitals.sort((a, b) {
          int comparison = 0;
          switch (sortBy) {
            case 'name':
              comparison = a.name.compareTo(b.name);
              break;
            case 'city':
              comparison = a.city.compareTo(b.city);
              break;
            case 'totalBeds':
              comparison = a.totalBeds.compareTo(b.totalBeds);
              break;
            default:
              comparison = 0;
          }
          return ascending ? comparison : -comparison;
        });
      }
      
      // Apply pagination
      final startIndex = page * limit;
      final endIndex = (startIndex + limit).clamp(0, filteredHospitals.length);
      final paginatedHospitals = filteredHospitals.sublist(startIndex, endIndex);
      return Result.success(paginatedHospitals);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch paginated hospitals: ${e.toString()}'),
      );
    }
  }
}
