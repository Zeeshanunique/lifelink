import '../models/analytics.dart';

abstract class AnalyticsService {
  Future<DashboardStats> getDashboardStats();
  Future<HospitalAnalytics> getHospitalAnalytics(String hospitalId);
  Future<DonorAnalytics> getDonorAnalytics();
  Future<List<TransplantReport>> getTransplantReports(Map<String, dynamic> filters);
}

class MockAnalyticsService implements AnalyticsService {
  @override
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return DashboardStats(
      totalHospitals: 25,
      totalPatients: 1240,
      totalDonors: 856,
      totalAppointments: 2134,
      activeDonors: 654,
      pendingRequests: 45,
      completedTransplants: 189,
      donorMatchRate: 0.78,
      hospitalsByType: {
        'General': 12,
        'Specialty': 8,
        'Teaching': 3,
        'Emergency': 2,
      },
      donorsByBloodType: {
        'O+': 280,
        'A+': 210,
        'B+': 140,
        'AB+': 80,
        'O-': 75,
        'A-': 45,
        'B-': 20,
        'AB-': 6,
      },
      donorsByOrgan: {
        'Kidney': 420,
        'Liver': 230,
        'Heart': 145,
        'Lung': 98,
        'Cornea': 180,
        'Pancreas': 65,
      },
      dailyStats: List.generate(7, (index) {
        final date = DateTime.now().subtract(Duration(days: 6 - index));
        return DailyStats(
          date: date,
          newDonors: 5 + (index * 2),
          newRequests: 3 + index,
          completedMatches: 1 + (index % 3),
          newAppointments: 15 + (index * 3),
        );
      }),
    );
  }

  @override
  Future<HospitalAnalytics> getHospitalAnalytics(String hospitalId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return HospitalAnalytics(
      id: 'analytics_$hospitalId',
      hospitalId: hospitalId,
      hospitalName: 'City General Hospital',
      totalPatients: 450,
      totalDonors: 120,
      totalAppointments: 890,
      completedTransplants: 45,
      pendingRequests: 12,
      averageWaitTime: 28.5,
      successRate: 0.92,
      specialtyBreakdown: {
        'Cardiology': 145,
        'Nephrology': 98,
        'Hepatology': 67,
        'Pulmonology': 89,
        'Transplant Surgery': 51,
      },
      monthlyStats: {
        'Jan': 78,
        'Feb': 84,
        'Mar': 92,
        'Apr': 76,
        'May': 89,
        'Jun': 95,
      },
      topDoctors: [
        'Dr. Sarah Johnson',
        'Dr. Michael Chen',
        'Dr. Emily Rodriguez',
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<DonorAnalytics> getDonorAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    return DonorAnalytics(
      id: 'donor_analytics_1',
      totalRegistered: 856,
      activeCount: 654,
      deceasedCount: 67,
      transplantedCount: 135,
      byBloodType: {
        'O+': 280,
        'A+': 210,
        'B+': 140,
        'AB+': 80,
        'O-': 75,
        'A-': 45,
        'B-': 20,
        'AB-': 6,
      },
      byOrganType: {
        'Kidney': 420,
        'Liver': 230,
        'Heart': 145,
        'Lung': 98,
        'Cornea': 180,
        'Pancreas': 65,
      },
      byAgeGroup: {
        '18-25': 156,
        '26-35': 234,
        '36-45': 198,
        '46-55': 167,
        '56-65': 89,
        '65+': 12,
      },
      byGender: {
        'Male': 478,
        'Female': 364,
        'Other': 14,
      },
      byLocation: {
        'New York': 234,
        'California': 189,
        'Texas': 156,
        'Florida': 134,
        'Illinois': 89,
        'Others': 54,
      },
      averageAge: 38.2,
      registrationsThisMonth: 24,
      matchesThisMonth: 18,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<TransplantReport>> getTransplantReports(Map<String, dynamic> filters) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return List.generate(10, (index) {
      return TransplantReport(
        id: 'report_$index',
        hospitalId: 'hospital_${index % 3 + 1}',
        patientId: 'patient_$index',
        donorId: 'donor_$index',
        organType: ['Heart', 'Kidney', 'Liver', 'Lung'][index % 4],
        transplantDate: DateTime.now().subtract(Duration(days: index * 7)),
        status: 'Completed',
        outcome: index % 10 == 0 ? 'Complications' : 'Successful',
        waitTimeInDays: 30 + (index * 5),
        medicalDetails: {
          'surgery_duration': '${4 + index % 3} hours',
          'blood_loss': '${200 + index * 50}ml',
          'complications': index % 10 == 0 ? 'Minor bleeding' : 'None',
        },
        performingSurgeon: 'Dr. ${['Smith', 'Johnson', 'Chen', 'Rodriguez'][index % 4]}',
        notes: 'Surgery completed successfully with standard recovery.',
        createdAt: DateTime.now().subtract(Duration(days: index * 7)),
        updatedAt: DateTime.now(),
      );
    });
  }
}