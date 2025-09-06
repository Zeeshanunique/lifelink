import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'organ_donor.g.dart';

@JsonSerializable()
class OrganDonor extends BaseModel {
  final String patientId;
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
  final String status;
  final String? hospitalId;
  final List<String> organsToDonate;
  final List<String> organsDonated;
  final Map<String, dynamic>? medicalHistory;
  final List<String>? allergies;
  final List<String>? medications;
  final String? notes;
  final DateTime? lastHealthCheck;
  final String? healthStatus;
  final bool isCompatibleWithRecipient;
  final String? matchingRecipientId;
  final DateTime? registrationDate;
  final DateTime? lastUpdated;
  final Map<String, dynamic>? donorPreferences;
  final bool isDeceased;
  final DateTime? deathDate;
  final String? causeOfDeath;
  final bool isTransplanted;
  final DateTime? transplantDate;
  final String? transplantHospitalId;

  const OrganDonor({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.patientId,
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
    this.status = 'Registered',
    this.hospitalId,
    required this.organsToDonate,
    this.organsDonated = const [],
    this.medicalHistory,
    this.allergies,
    this.medications,
    this.notes,
    this.lastHealthCheck,
    this.healthStatus,
    this.isCompatibleWithRecipient = false,
    this.matchingRecipientId,
    this.registrationDate,
    this.lastUpdated,
    this.donorPreferences,
    this.isDeceased = false,
    this.deathDate,
    this.causeOfDeath,
    this.isTransplanted = false,
    this.transplantDate,
    this.transplantHospitalId,
  });

  String get fullName => middleName != null
      ? '$firstName $middleName $lastName'
      : '$firstName $lastName';

  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  int get age => DateTime.now().difference(dateOfBirth).inDays ~/ 365;

  String get fullAddress => '$address, $city, $state, $country';

  bool get hasEmergencyContact =>
      emergencyContactName != null && emergencyContactPhone != null;

  bool get isActive => status == 'Active' && !isDeceased && !isTransplanted;

  bool get canDonate => isActive && organsToDonate.isNotEmpty;

  List<String> get availableOrgans {
    if (isDeceased) {
      return organsToDonate
          .where((organ) => !organsDonated.contains(organ))
          .toList();
    }
    return [];
  }

  factory OrganDonor.fromJson(Map<String, dynamic> json) =>
      _$OrganDonorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrganDonorToJson(this);

  OrganDonor copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? patientId,
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
    String? status,
    String? hospitalId,
    List<String>? organsToDonate,
    List<String>? organsDonated,
    Map<String, dynamic>? medicalHistory,
    List<String>? allergies,
    List<String>? medications,
    String? notes,
    DateTime? lastHealthCheck,
    String? healthStatus,
    bool? isCompatibleWithRecipient,
    String? matchingRecipientId,
    DateTime? registrationDate,
    DateTime? lastUpdated,
    Map<String, dynamic>? donorPreferences,
    bool? isDeceased,
    DateTime? deathDate,
    String? causeOfDeath,
    bool? isTransplanted,
    DateTime? transplantDate,
    String? transplantHospitalId,
  }) {
    return OrganDonor(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      patientId: patientId ?? this.patientId,
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
      status: status ?? this.status,
      hospitalId: hospitalId ?? this.hospitalId,
      organsToDonate: organsToDonate ?? this.organsToDonate,
      organsDonated: organsDonated ?? this.organsDonated,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      lastHealthCheck: lastHealthCheck ?? this.lastHealthCheck,
      healthStatus: healthStatus ?? this.healthStatus,
      isCompatibleWithRecipient:
          isCompatibleWithRecipient ?? this.isCompatibleWithRecipient,
      matchingRecipientId: matchingRecipientId ?? this.matchingRecipientId,
      registrationDate: registrationDate ?? this.registrationDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      donorPreferences: donorPreferences ?? this.donorPreferences,
      isDeceased: isDeceased ?? this.isDeceased,
      deathDate: deathDate ?? this.deathDate,
      causeOfDeath: causeOfDeath ?? this.causeOfDeath,
      isTransplanted: isTransplanted ?? this.isTransplanted,
      transplantDate: transplantDate ?? this.transplantDate,
      transplantHospitalId: transplantHospitalId ?? this.transplantHospitalId,
    );
  }
}
