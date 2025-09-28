import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'auth_user.g.dart';

enum UserRole { patient, hospital, admin }

@JsonSerializable()
class AuthUser extends BaseModel {
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final UserRole role;
  final bool isActive;
  final bool isVerified;
  final String? profileImageUrl;
  final Map<String, dynamic>? metadata;
  final DateTime? lastLoginAt;
  final String? hospitalId; // For hospital users
  final String? patientId; // For patient users

  const AuthUser({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.role,
    this.isActive = true,
    this.isVerified = false,
    this.profileImageUrl,
    this.metadata,
    this.lastLoginAt,
    this.hospitalId,
    this.patientId,
  });

  String get fullName => '$firstName $lastName';

  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  bool get isPatient => role == UserRole.patient;
  bool get isHospital => role == UserRole.hospital;
  bool get isAdmin => role == UserRole.admin;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthUserToJson(this);

  AuthUser copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    UserRole? role,
    bool? isActive,
    bool? isVerified,
    String? profileImageUrl,
    Map<String, dynamic>? metadata,
    DateTime? lastLoginAt,
    String? hospitalId,
    String? patientId,
  }) {
    return AuthUser(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      metadata: metadata ?? this.metadata,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      hospitalId: hospitalId ?? this.hospitalId,
      patientId: patientId ?? this.patientId,
    );
  }
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final UserRole role;

  const LoginRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final UserRole role;
  final String? hospitalId;
  final Map<String, dynamic>? additionalData;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.role,
    this.hospitalId,
    this.additionalData,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final AuthUser user;
  final String token;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}