// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String?,
  updatedBy: json['updatedBy'] as String?,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  role: json['role'] as String,
  profileImage: json['profileImage'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  hospitalId: json['hospitalId'] as String?,
  department: json['department'] as String?,
  permissions: json['permissions'] as Map<String, dynamic>?,
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phoneNumber': instance.phoneNumber,
  'role': instance.role,
  'profileImage': instance.profileImage,
  'isActive': instance.isActive,
  'hospitalId': instance.hospitalId,
  'department': instance.department,
  'permissions': instance.permissions,
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
};
