// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonorRequest _$DonorRequestFromJson(Map<String, dynamic> json) => DonorRequest(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  updatedBy: json['updatedBy'] as String?,
  patientId: json['patientId'] as String,
  hospitalId: json['hospitalId'] as String,
  requestingDoctorId: json['requestingDoctorId'] as String,
  organsNeeded: (json['organsNeeded'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  bloodType: json['bloodType'] as String,
  urgency: $enumDecode(_$RequestUrgencyEnumMap, json['urgency']),
  status:
      $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
      RequestStatus.pending,
  medicalReason: json['medicalReason'] as String,
  medicalRequirements: json['medicalRequirements'] as Map<String, dynamic>,
  neededBy: DateTime.parse(json['neededBy'] as String),
  notes: json['notes'] as String?,
  matchedDonorIds: (json['matchedDonorIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  selectedDonorId: json['selectedDonorId'] as String?,
  matchedAt: json['matchedAt'] == null
      ? null
      : DateTime.parse(json['matchedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  rejectionReason: json['rejectionReason'] as String?,
  compatibility: json['compatibility'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$DonorRequestToJson(DonorRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'patientId': instance.patientId,
      'hospitalId': instance.hospitalId,
      'requestingDoctorId': instance.requestingDoctorId,
      'organsNeeded': instance.organsNeeded,
      'bloodType': instance.bloodType,
      'urgency': _$RequestUrgencyEnumMap[instance.urgency]!,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'medicalReason': instance.medicalReason,
      'medicalRequirements': instance.medicalRequirements,
      'neededBy': instance.neededBy.toIso8601String(),
      'notes': instance.notes,
      'matchedDonorIds': instance.matchedDonorIds,
      'selectedDonorId': instance.selectedDonorId,
      'matchedAt': instance.matchedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'rejectionReason': instance.rejectionReason,
      'compatibility': instance.compatibility,
    };

const _$RequestUrgencyEnumMap = {
  RequestUrgency.low: 'low',
  RequestUrgency.medium: 'medium',
  RequestUrgency.high: 'high',
  RequestUrgency.critical: 'critical',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
  RequestStatus.matched: 'matched',
  RequestStatus.completed: 'completed',
  RequestStatus.cancelled: 'cancelled',
};
