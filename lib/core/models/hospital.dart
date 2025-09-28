import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'hospital.g.dart';

@JsonSerializable()
class Hospital extends BaseModel {
  final String name;
  final String type;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String? description;
  final String? status;
  final String? phoneNumber;
  final String? email;
  final String? website;
  final double latitude;
  final double longitude;
  final int totalBeds;
  final int icuBeds;
  final int emergencyBeds;
  final List<String> specialties;
  final List<String> services;
  final bool isActive;
  final String? licenseNumber;
  final DateTime? licenseExpiry;
  final Map<String, dynamic>? facilities;
  final List<String>? organTransplantCapabilities;

  const Hospital({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.description,
    this.status,
    this.phoneNumber,
    this.email,
    this.website,
    required this.latitude,
    required this.longitude,
    required this.totalBeds,
    required this.icuBeds,
    required this.emergencyBeds,
    required this.specialties,
    required this.services,
    this.isActive = true,
    this.licenseNumber,
    this.licenseExpiry,
    this.facilities,
    this.organTransplantCapabilities,
  });

  String get fullAddress => '$address, $city, $state $postalCode, $country';

  bool get hasOrganTransplantCapability =>
      organTransplantCapabilities != null &&
      organTransplantCapabilities!.isNotEmpty;

  bool get isLicenseValid =>
      licenseExpiry == null || licenseExpiry!.isAfter(DateTime.now());

  factory Hospital.fromJson(Map<String, dynamic> json) =>
      _$HospitalFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HospitalToJson(this);

  Hospital copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? name,
    String? type,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? description,
    String? status,
    String? phoneNumber,
    String? email,
    String? website,
    double? latitude,
    double? longitude,
    int? totalBeds,
    int? icuBeds,
    int? emergencyBeds,
    List<String>? specialties,
    List<String>? services,
    bool? isActive,
    String? licenseNumber,
    DateTime? licenseExpiry,
    Map<String, dynamic>? facilities,
    List<String>? organTransplantCapabilities,
  }) {
    return Hospital(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      description: description ?? this.description,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalBeds: totalBeds ?? this.totalBeds,
      icuBeds: icuBeds ?? this.icuBeds,
      emergencyBeds: emergencyBeds ?? this.emergencyBeds,
      specialties: specialties ?? this.specialties,
      services: services ?? this.services,
      isActive: isActive ?? this.isActive,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      facilities: facilities ?? this.facilities,
      organTransplantCapabilities:
          organTransplantCapabilities ?? this.organTransplantCapabilities,
    );
  }
}
