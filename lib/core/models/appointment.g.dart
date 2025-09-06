// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  updatedBy: json['updatedBy'] as String?,
  patientId: json['patientId'] as String,
  doctorId: json['doctorId'] as String,
  hospitalId: json['hospitalId'] as String?,
  scheduledDate: DateTime.parse(json['scheduledDate'] as String),
  timeSlot: json['timeSlot'] as String,
  status: json['status'] as String? ?? 'Scheduled',
  type: json['type'] as String,
  department: json['department'] as String?,
  roomNumber: json['roomNumber'] as String?,
  notes: json['notes'] as String?,
  diagnosis: json['diagnosis'] as String?,
  prescription: json['prescription'] as String?,
  labTests: (json['labTests'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  followUpInstructions: (json['followUpInstructions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  vitalSigns: json['vitalSigns'] as Map<String, dynamic>?,
  chiefComplaint: json['chiefComplaint'] as String?,
  medicalHistory: json['medicalHistory'] as String?,
  physicalExamination: json['physicalExamination'] as String?,
  treatmentPlan: json['treatmentPlan'] as String?,
  isEmergency: json['isEmergency'] as bool? ?? false,
  duration: (json['duration'] as num?)?.toInt() ?? 30,
  cancellationReason: json['cancellationReason'] as String?,
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  cancelledBy: json['cancelledBy'] as String?,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  completedBy: json['completedBy'] as String?,
  attachments: json['attachments'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
      'hospitalId': instance.hospitalId,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'status': instance.status,
      'type': instance.type,
      'department': instance.department,
      'roomNumber': instance.roomNumber,
      'notes': instance.notes,
      'diagnosis': instance.diagnosis,
      'prescription': instance.prescription,
      'labTests': instance.labTests,
      'followUpInstructions': instance.followUpInstructions,
      'vitalSigns': instance.vitalSigns,
      'chiefComplaint': instance.chiefComplaint,
      'medicalHistory': instance.medicalHistory,
      'physicalExamination': instance.physicalExamination,
      'treatmentPlan': instance.treatmentPlan,
      'isEmergency': instance.isEmergency,
      'duration': instance.duration,
      'cancellationReason': instance.cancellationReason,
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancelledBy': instance.cancelledBy,
      'completedAt': instance.completedAt?.toIso8601String(),
      'completedBy': instance.completedBy,
      'attachments': instance.attachments,
    };
