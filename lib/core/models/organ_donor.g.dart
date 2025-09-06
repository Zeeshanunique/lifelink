// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organ_donor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganDonor _$OrganDonorFromJson(Map<String, dynamic> json) => OrganDonor(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  updatedBy: json['updatedBy'] as String?,
  patientId: json['patientId'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  middleName: json['middleName'] as String?,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String,
  bloodType: json['bloodType'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  country: json['country'] as String,
  emergencyContactName: json['emergencyContactName'] as String?,
  emergencyContactPhone: json['emergencyContactPhone'] as String?,
  emergencyContactRelation: json['emergencyContactRelation'] as String?,
  status: json['status'] as String? ?? 'Registered',
  hospitalId: json['hospitalId'] as String?,
  organsToDonate: (json['organsToDonate'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  organsDonated:
      (json['organsDonated'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  medicalHistory: json['medicalHistory'] as Map<String, dynamic>?,
  allergies: (json['allergies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  medications: (json['medications'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  notes: json['notes'] as String?,
  lastHealthCheck: json['lastHealthCheck'] == null
      ? null
      : DateTime.parse(json['lastHealthCheck'] as String),
  healthStatus: json['healthStatus'] as String?,
  isCompatibleWithRecipient:
      json['isCompatibleWithRecipient'] as bool? ?? false,
  matchingRecipientId: json['matchingRecipientId'] as String?,
  registrationDate: json['registrationDate'] == null
      ? null
      : DateTime.parse(json['registrationDate'] as String),
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
  donorPreferences: json['donorPreferences'] as Map<String, dynamic>?,
  isDeceased: json['isDeceased'] as bool? ?? false,
  deathDate: json['deathDate'] == null
      ? null
      : DateTime.parse(json['deathDate'] as String),
  causeOfDeath: json['causeOfDeath'] as String?,
  isTransplanted: json['isTransplanted'] as bool? ?? false,
  transplantDate: json['transplantDate'] == null
      ? null
      : DateTime.parse(json['transplantDate'] as String),
  transplantHospitalId: json['transplantHospitalId'] as String?,
);

Map<String, dynamic> _$OrganDonorToJson(OrganDonor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'patientId': instance.patientId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'bloodType': instance.bloodType,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactPhone': instance.emergencyContactPhone,
      'emergencyContactRelation': instance.emergencyContactRelation,
      'status': instance.status,
      'hospitalId': instance.hospitalId,
      'organsToDonate': instance.organsToDonate,
      'organsDonated': instance.organsDonated,
      'medicalHistory': instance.medicalHistory,
      'allergies': instance.allergies,
      'medications': instance.medications,
      'notes': instance.notes,
      'lastHealthCheck': instance.lastHealthCheck?.toIso8601String(),
      'healthStatus': instance.healthStatus,
      'isCompatibleWithRecipient': instance.isCompatibleWithRecipient,
      'matchingRecipientId': instance.matchingRecipientId,
      'registrationDate': instance.registrationDate?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'donorPreferences': instance.donorPreferences,
      'isDeceased': instance.isDeceased,
      'deathDate': instance.deathDate?.toIso8601String(),
      'causeOfDeath': instance.causeOfDeath,
      'isTransplanted': instance.isTransplanted,
      'transplantDate': instance.transplantDate?.toIso8601String(),
      'transplantHospitalId': instance.transplantHospitalId,
    };
