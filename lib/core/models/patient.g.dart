// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  updatedBy: json['updatedBy'] as String?,
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
  zipCode: json['zipCode'] as String?,
  emergencyContactName: json['emergencyContactName'] as String?,
  emergencyContactPhone: json['emergencyContactPhone'] as String?,
  emergencyContactRelation: json['emergencyContactRelation'] as String?,
  medicalRecordNumber: json['medicalRecordNumber'] as String?,
  insuranceProvider: json['insuranceProvider'] as String?,
  insuranceNumber: json['insuranceNumber'] as String?,
  status: json['status'] as String? ?? 'Active',
  hospitalId: json['hospitalId'] as String?,
  assignedDoctorId: json['assignedDoctorId'] as String?,
  assignedNurseId: json['assignedNurseId'] as String?,
  medicalHistory: json['medicalHistory'] as Map<String, dynamic>?,
  allergies: (json['allergies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  medications: (json['medications'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  vitalSigns: json['vitalSigns'] as Map<String, dynamic>?,
  notes: json['notes'] as String?,
  isOrganDonor: json['isOrganDonor'] as bool? ?? false,
  donorRegistrationId: json['donorRegistrationId'] as String?,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
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
  'zipCode': instance.zipCode,
  'emergencyContactName': instance.emergencyContactName,
  'emergencyContactPhone': instance.emergencyContactPhone,
  'emergencyContactRelation': instance.emergencyContactRelation,
  'medicalRecordNumber': instance.medicalRecordNumber,
  'insuranceProvider': instance.insuranceProvider,
  'insuranceNumber': instance.insuranceNumber,
  'status': instance.status,
  'hospitalId': instance.hospitalId,
  'assignedDoctorId': instance.assignedDoctorId,
  'assignedNurseId': instance.assignedNurseId,
  'medicalHistory': instance.medicalHistory,
  'allergies': instance.allergies,
  'medications': instance.medications,
  'vitalSigns': instance.vitalSigns,
  'notes': instance.notes,
  'isOrganDonor': instance.isOrganDonor,
  'donorRegistrationId': instance.donorRegistrationId,
};
