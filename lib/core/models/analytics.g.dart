// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      totalHospitals: (json['totalHospitals'] as num).toInt(),
      totalPatients: (json['totalPatients'] as num).toInt(),
      totalDonors: (json['totalDonors'] as num).toInt(),
      totalAppointments: (json['totalAppointments'] as num).toInt(),
      activeDonors: (json['activeDonors'] as num).toInt(),
      pendingRequests: (json['pendingRequests'] as num).toInt(),
      completedTransplants: (json['completedTransplants'] as num).toInt(),
      donorMatchRate: (json['donorMatchRate'] as num).toDouble(),
      hospitalsByType: Map<String, int>.from(json['hospitalsByType'] as Map),
      donorsByBloodType: Map<String, int>.from(
        json['donorsByBloodType'] as Map,
      ),
      donorsByOrgan: Map<String, int>.from(json['donorsByOrgan'] as Map),
      dailyStats: (json['dailyStats'] as List<dynamic>)
          .map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'totalHospitals': instance.totalHospitals,
      'totalPatients': instance.totalPatients,
      'totalDonors': instance.totalDonors,
      'totalAppointments': instance.totalAppointments,
      'activeDonors': instance.activeDonors,
      'pendingRequests': instance.pendingRequests,
      'completedTransplants': instance.completedTransplants,
      'donorMatchRate': instance.donorMatchRate,
      'hospitalsByType': instance.hospitalsByType,
      'donorsByBloodType': instance.donorsByBloodType,
      'donorsByOrgan': instance.donorsByOrgan,
      'dailyStats': instance.dailyStats,
    };

DailyStats _$DailyStatsFromJson(Map<String, dynamic> json) => DailyStats(
  date: DateTime.parse(json['date'] as String),
  newDonors: (json['newDonors'] as num).toInt(),
  newRequests: (json['newRequests'] as num).toInt(),
  completedMatches: (json['completedMatches'] as num).toInt(),
  newAppointments: (json['newAppointments'] as num).toInt(),
);

Map<String, dynamic> _$DailyStatsToJson(DailyStats instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'newDonors': instance.newDonors,
      'newRequests': instance.newRequests,
      'completedMatches': instance.completedMatches,
      'newAppointments': instance.newAppointments,
    };

HospitalAnalytics _$HospitalAnalyticsFromJson(Map<String, dynamic> json) =>
    HospitalAnalytics(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      hospitalId: json['hospitalId'] as String,
      hospitalName: json['hospitalName'] as String,
      totalPatients: (json['totalPatients'] as num).toInt(),
      totalDonors: (json['totalDonors'] as num).toInt(),
      totalAppointments: (json['totalAppointments'] as num).toInt(),
      completedTransplants: (json['completedTransplants'] as num).toInt(),
      pendingRequests: (json['pendingRequests'] as num).toInt(),
      averageWaitTime: (json['averageWaitTime'] as num).toDouble(),
      successRate: (json['successRate'] as num).toDouble(),
      specialtyBreakdown: Map<String, int>.from(
        json['specialtyBreakdown'] as Map,
      ),
      monthlyStats: Map<String, int>.from(json['monthlyStats'] as Map),
      topDoctors: (json['topDoctors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HospitalAnalyticsToJson(HospitalAnalytics instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'hospitalId': instance.hospitalId,
      'hospitalName': instance.hospitalName,
      'totalPatients': instance.totalPatients,
      'totalDonors': instance.totalDonors,
      'totalAppointments': instance.totalAppointments,
      'completedTransplants': instance.completedTransplants,
      'pendingRequests': instance.pendingRequests,
      'averageWaitTime': instance.averageWaitTime,
      'successRate': instance.successRate,
      'specialtyBreakdown': instance.specialtyBreakdown,
      'monthlyStats': instance.monthlyStats,
      'topDoctors': instance.topDoctors,
    };

DonorAnalytics _$DonorAnalyticsFromJson(Map<String, dynamic> json) =>
    DonorAnalytics(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      totalRegistered: (json['totalRegistered'] as num).toInt(),
      activeCount: (json['activeCount'] as num).toInt(),
      deceasedCount: (json['deceasedCount'] as num).toInt(),
      transplantedCount: (json['transplantedCount'] as num).toInt(),
      byBloodType: Map<String, int>.from(json['byBloodType'] as Map),
      byOrganType: Map<String, int>.from(json['byOrganType'] as Map),
      byAgeGroup: Map<String, int>.from(json['byAgeGroup'] as Map),
      byGender: Map<String, int>.from(json['byGender'] as Map),
      byLocation: Map<String, int>.from(json['byLocation'] as Map),
      averageAge: (json['averageAge'] as num).toDouble(),
      registrationsThisMonth: (json['registrationsThisMonth'] as num).toInt(),
      matchesThisMonth: (json['matchesThisMonth'] as num).toInt(),
    );

Map<String, dynamic> _$DonorAnalyticsToJson(DonorAnalytics instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'totalRegistered': instance.totalRegistered,
      'activeCount': instance.activeCount,
      'deceasedCount': instance.deceasedCount,
      'transplantedCount': instance.transplantedCount,
      'byBloodType': instance.byBloodType,
      'byOrganType': instance.byOrganType,
      'byAgeGroup': instance.byAgeGroup,
      'byGender': instance.byGender,
      'byLocation': instance.byLocation,
      'averageAge': instance.averageAge,
      'registrationsThisMonth': instance.registrationsThisMonth,
      'matchesThisMonth': instance.matchesThisMonth,
    };

TransplantReport _$TransplantReportFromJson(Map<String, dynamic> json) =>
    TransplantReport(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      hospitalId: json['hospitalId'] as String,
      patientId: json['patientId'] as String,
      donorId: json['donorId'] as String,
      organType: json['organType'] as String,
      transplantDate: DateTime.parse(json['transplantDate'] as String),
      status: json['status'] as String,
      outcome: json['outcome'] as String,
      waitTimeInDays: (json['waitTimeInDays'] as num).toInt(),
      medicalDetails: json['medicalDetails'] as Map<String, dynamic>,
      performingSurgeon: json['performingSurgeon'] as String,
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$TransplantReportToJson(TransplantReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'hospitalId': instance.hospitalId,
      'patientId': instance.patientId,
      'donorId': instance.donorId,
      'organType': instance.organType,
      'transplantDate': instance.transplantDate.toIso8601String(),
      'status': instance.status,
      'outcome': instance.outcome,
      'waitTimeInDays': instance.waitTimeInDays,
      'medicalDetails': instance.medicalDetails,
      'performingSurgeon': instance.performingSurgeon,
      'notes': instance.notes,
    };

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) =>
    ReportRequest(
      type: $enumDecode(_$ReportTypeEnumMap, json['type']),
      format: $enumDecode(_$ReportFormatEnumMap, json['format']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      hospitalIds:
          (json['hospitalIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metrics:
          (json['metrics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      filters: json['filters'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'type': _$ReportTypeEnumMap[instance.type]!,
      'format': _$ReportFormatEnumMap[instance.format]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'hospitalIds': instance.hospitalIds,
      'metrics': instance.metrics,
      'filters': instance.filters,
    };

const _$ReportTypeEnumMap = {
  ReportType.daily: 'daily',
  ReportType.weekly: 'weekly',
  ReportType.monthly: 'monthly',
  ReportType.quarterly: 'quarterly',
  ReportType.yearly: 'yearly',
  ReportType.custom: 'custom',
};

const _$ReportFormatEnumMap = {
  ReportFormat.pdf: 'pdf',
  ReportFormat.excel: 'excel',
  ReportFormat.json: 'json',
  ReportFormat.csv: 'csv',
};
