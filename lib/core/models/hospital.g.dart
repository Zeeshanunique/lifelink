// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hospital _$HospitalFromJson(Map<String, dynamic> json) => Hospital(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  updatedBy: json['updatedBy'] as String?,
  name: json['name'] as String,
  type: json['type'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  country: json['country'] as String,
  postalCode: json['postalCode'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  email: json['email'] as String?,
  website: json['website'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  totalBeds: (json['totalBeds'] as num).toInt(),
  icuBeds: (json['icuBeds'] as num).toInt(),
  emergencyBeds: (json['emergencyBeds'] as num).toInt(),
  specialties: (json['specialties'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  services: (json['services'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isActive: json['isActive'] as bool? ?? true,
  licenseNumber: json['licenseNumber'] as String?,
  licenseExpiry: json['licenseExpiry'] == null
      ? null
      : DateTime.parse(json['licenseExpiry'] as String),
  facilities: json['facilities'] as Map<String, dynamic>?,
  organTransplantCapabilities:
      (json['organTransplantCapabilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$HospitalToJson(Hospital instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'name': instance.name,
  'type': instance.type,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'postalCode': instance.postalCode,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'website': instance.website,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'totalBeds': instance.totalBeds,
  'icuBeds': instance.icuBeds,
  'emergencyBeds': instance.emergencyBeds,
  'specialties': instance.specialties,
  'services': instance.services,
  'isActive': instance.isActive,
  'licenseNumber': instance.licenseNumber,
  'licenseExpiry': instance.licenseExpiry?.toIso8601String(),
  'facilities': instance.facilities,
  'organTransplantCapabilities': instance.organTransplantCapabilities,
};
