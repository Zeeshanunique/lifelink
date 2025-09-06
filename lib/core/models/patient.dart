import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient extends BaseModel {
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodType;
  final String? phoneNumber;
  final String? email;
  final String address;
  final String city;
  final String state;
  final String country;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final String? medicalRecordNumber;
  final String? insuranceProvider;
  final String? insuranceNumber;
  final String status;
  final String? hospitalId;
  final String? assignedDoctorId;
  final String? assignedNurseId;
  final Map<String, dynamic>? medicalHistory;
  final List<String>? allergies;
  final List<String>? medications;
  final Map<String, dynamic>? vitalSigns;
  final String? notes;
  final bool isOrganDonor;
  final String? donorRegistrationId;

  const Patient({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    this.phoneNumber,
    this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.medicalRecordNumber,
    this.insuranceProvider,
    this.insuranceNumber,
    this.status = 'Active',
    this.hospitalId,
    this.assignedDoctorId,
    this.assignedNurseId,
    this.medicalHistory,
    this.allergies,
    this.medications,
    this.vitalSigns,
    this.notes,
    this.isOrganDonor = false,
    this.donorRegistrationId,
  });

  String get fullName => middleName != null
      ? '$firstName $middleName $lastName'
      : '$firstName $lastName';

  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  int get age => DateTime.now().difference(dateOfBirth).inDays ~/ 365;

  String get fullAddress => '$address, $city, $state, $country';

  bool get hasEmergencyContact =>
      emergencyContactName != null && emergencyContactPhone != null;

  bool get hasInsurance => insuranceProvider != null && insuranceNumber != null;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PatientToJson(this);

  Patient copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? phoneNumber,
    String? email,
    String? address,
    String? city,
    String? state,
    String? country,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? medicalRecordNumber,
    String? insuranceProvider,
    String? insuranceNumber,
    String? status,
    String? hospitalId,
    String? assignedDoctorId,
    String? assignedNurseId,
    Map<String, dynamic>? medicalHistory,
    List<String>? allergies,
    List<String>? medications,
    Map<String, dynamic>? vitalSigns,
    String? notes,
    bool? isOrganDonor,
    String? donorRegistrationId,
  }) {
    return Patient(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      medicalRecordNumber: medicalRecordNumber ?? this.medicalRecordNumber,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      status: status ?? this.status,
      hospitalId: hospitalId ?? this.hospitalId,
      assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
      assignedNurseId: assignedNurseId ?? this.assignedNurseId,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      notes: notes ?? this.notes,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      donorRegistrationId: donorRegistrationId ?? this.donorRegistrationId,
    );
  }
}
