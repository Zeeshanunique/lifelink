import '../models/donor_request.dart';

abstract class DonorMatchingService {
  Future<List<dynamic>> getActiveMatches();
  Future<List<DonorRequest>> getPendingRequests();
  Future<List<dynamic>> getCompletedMatches();
  Future<List<dynamic>> getCompatibleDonors(String requestId);
  Future<void> findMatches(String requestId);
  Future<void> acceptMatch(String matchId);
  Future<void> rejectMatch(String matchId);
}

class MockDonorMatchingService implements DonorMatchingService {
  @override
  Future<List<dynamic>> getActiveMatches() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Return mock active matches
    return List.generate(3, (index) => {
      'id': 'match_$index',
      'donorId': 'donor_${index + 1}',
      'patientId': 'patient_${index + 1}',
      'organType': ['Heart', 'Kidney', 'Liver'][index],
      'matchPercentage': [95.0, 88.0, 92.0][index],
      'distance': [12.5, 8.3, 15.7][index],
      'urgency': ['Critical', 'High', 'Medium'][index],
      'createdAt': DateTime.now().subtract(Duration(hours: index + 1)),
    });
  }

  @override
  Future<List<DonorRequest>> getPendingRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return List.generate(5, (index) {
      return DonorRequest(
        id: 'request_$index',
        patientId: 'patient_${index + 1}',
        hospitalId: 'hospital_${(index % 3) + 1}',
        requestingDoctorId: 'doctor_${index + 1}',
        organsNeeded: [
          ['Heart'],
          ['Kidney'],
          ['Liver'],
          ['Heart', 'Lung'],
          ['Kidney']
        ][index],
        bloodType: ['O+', 'A+', 'B+', 'AB+', 'O-'][index],
        urgency: [
          RequestUrgency.critical,
          RequestUrgency.high,
          RequestUrgency.medium,
          RequestUrgency.critical,
          RequestUrgency.low
        ][index],
        medicalReason: [
          'End-stage heart failure',
          'Chronic kidney disease',
          'Liver cirrhosis',
          'Pulmonary hypertension',
          'Kidney failure'
        ][index],
        medicalRequirements: {
          'weight_range': '60-80kg',
          'age_range': '18-55',
          'no_diabetes': true,
        },
        neededBy: DateTime.now().add(Duration(days: [7, 30, 60, 14, 90][index])),
        notes: 'Urgent transplant needed for patient recovery',
        createdAt: DateTime.now().subtract(Duration(days: index + 1)),
        updatedAt: DateTime.now(),
      );
    });
  }

  @override
  Future<List<dynamic>> getCompletedMatches() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return List.generate(8, (index) => {
      'id': 'completed_$index',
      'donorId': 'donor_${index + 10}',
      'patientId': 'patient_${index + 10}',
      'organType': ['Heart', 'Kidney', 'Liver', 'Lung'][index % 4],
      'transplantDate': DateTime.now().subtract(Duration(days: (index + 1) * 15)),
      'outcome': index % 8 == 0 ? 'Complications' : 'Successful',
      'hospitalId': 'hospital_${(index % 3) + 1}',
      'surgeonId': 'surgeon_${index + 1}',
    });
  }

  @override
  Future<List<dynamic>> getCompatibleDonors(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    return List.generate(6, (index) => {
      'donorId': 'donor_compatible_$index',
      'firstName': ['John', 'Sarah', 'Michael', 'Emily', 'David', 'Lisa'][index],
      'lastName': ['Smith', 'Johnson', 'Brown', 'Davis', 'Wilson', 'Miller'][index],
      'bloodType': 'O+',
      'organType': 'Heart',
      'matchPercentage': [95.0, 92.0, 89.0, 87.0, 85.0, 82.0][index],
      'distance': [5.2, 8.7, 12.3, 15.8, 18.4, 22.1][index],
      'age': [28, 35, 42, 38, 29, 45][index],
      'location': 'City General Hospital',
    });
  }

  @override
  Future<void> findMatches(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Simulate finding matches for a request
  }

  @override
  Future<void> acceptMatch(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulate accepting a match
  }

  @override
  Future<void> rejectMatch(String matchId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simulate rejecting a match
  }
}