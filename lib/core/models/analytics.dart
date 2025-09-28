import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'analytics.g.dart';

@JsonSerializable()
class DashboardStats {
  final int totalHospitals;
  final int totalPatients;
  final int totalDonors;
  final int totalAppointments;
  final int activeDonors;
  final int pendingRequests;
  final int completedTransplants;
  final double donorMatchRate;
  final Map<String, int> hospitalsByType;
  final Map<String, int> donorsByBloodType;
  final Map<String, int> donorsByOrgan;
  final List<DailyStats> dailyStats;

  const DashboardStats({
    required this.totalHospitals,
    required this.totalPatients,
    required this.totalDonors,
    required this.totalAppointments,
    required this.activeDonors,
    required this.pendingRequests,
    required this.completedTransplants,
    required this.donorMatchRate,
    required this.hospitalsByType,
    required this.donorsByBloodType,
    required this.donorsByOrgan,
    required this.dailyStats,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}

@JsonSerializable()
class DailyStats {
  final DateTime date;
  final int newDonors;
  final int newRequests;
  final int completedMatches;
  final int newAppointments;

  const DailyStats({
    required this.date,
    required this.newDonors,
    required this.newRequests,
    required this.completedMatches,
    required this.newAppointments,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatsToJson(this);
}

@JsonSerializable()
class HospitalAnalytics extends BaseModel {
  final String hospitalId;
  final String hospitalName;
  final int totalPatients;
  final int totalDonors;
  final int totalAppointments;
  final int completedTransplants;
  final int pendingRequests;
  final double averageWaitTime;
  final double successRate;
  final Map<String, int> specialtyBreakdown;
  final Map<String, int> monthlyStats;
  final List<String> topDoctors;

  const HospitalAnalytics({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.hospitalId,
    required this.hospitalName,
    required this.totalPatients,
    required this.totalDonors,
    required this.totalAppointments,
    required this.completedTransplants,
    required this.pendingRequests,
    required this.averageWaitTime,
    required this.successRate,
    required this.specialtyBreakdown,
    required this.monthlyStats,
    required this.topDoctors,
  });

  factory HospitalAnalytics.fromJson(Map<String, dynamic> json) =>
      _$HospitalAnalyticsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HospitalAnalyticsToJson(this);
}

@JsonSerializable()
class DonorAnalytics extends BaseModel {
  final int totalRegistered;
  final int activeCount;
  final int deceasedCount;
  final int transplantedCount;
  final Map<String, int> byBloodType;
  final Map<String, int> byOrganType;
  final Map<String, int> byAgeGroup;
  final Map<String, int> byGender;
  final Map<String, int> byLocation;
  final double averageAge;
  final int registrationsThisMonth;
  final int matchesThisMonth;

  const DonorAnalytics({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.totalRegistered,
    required this.activeCount,
    required this.deceasedCount,
    required this.transplantedCount,
    required this.byBloodType,
    required this.byOrganType,
    required this.byAgeGroup,
    required this.byGender,
    required this.byLocation,
    required this.averageAge,
    required this.registrationsThisMonth,
    required this.matchesThisMonth,
  });

  factory DonorAnalytics.fromJson(Map<String, dynamic> json) =>
      _$DonorAnalyticsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DonorAnalyticsToJson(this);
}

@JsonSerializable()
class TransplantReport extends BaseModel {
  final String hospitalId;
  final String patientId;
  final String donorId;
  final String organType;
  final DateTime transplantDate;
  final String status;
  final String outcome;
  final int waitTimeInDays;
  final Map<String, dynamic> medicalDetails;
  final String performingSurgeon;
  final String notes;

  const TransplantReport({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.hospitalId,
    required this.patientId,
    required this.donorId,
    required this.organType,
    required this.transplantDate,
    required this.status,
    required this.outcome,
    required this.waitTimeInDays,
    required this.medicalDetails,
    required this.performingSurgeon,
    required this.notes,
  });

  bool get isSuccessful => outcome.toLowerCase() == 'successful';

  factory TransplantReport.fromJson(Map<String, dynamic> json) =>
      _$TransplantReportFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransplantReportToJson(this);
}

enum ReportType {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom
}

enum ReportFormat {
  pdf,
  excel,
  json,
  csv
}

@JsonSerializable()
class ReportRequest {
  final ReportType type;
  final ReportFormat format;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> hospitalIds;
  final List<String> metrics;
  final Map<String, dynamic> filters;

  const ReportRequest({
    required this.type,
    required this.format,
    required this.startDate,
    required this.endDate,
    this.hospitalIds = const [],
    this.metrics = const [],
    this.filters = const {},
  });

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}