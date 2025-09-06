import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BaseModel {
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String role;
  final String? profileImage;
  final bool isActive;
  final String? hospitalId;
  final String? department;
  final Map<String, dynamic>? permissions;
  final DateTime? lastLoginAt;

  const User({
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
    this.profileImage,
    this.isActive = true,
    this.hospitalId,
    this.department,
    this.permissions,
    this.lastLoginAt,
  });

  String get fullName => '$firstName $lastName';

  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  bool get isAdmin => role.toLowerCase() == 'admin';

  bool get isDoctor => role.toLowerCase() == 'doctor';

  bool get isNurse => role.toLowerCase() == 'nurse';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? role,
    String? profileImage,
    bool? isActive,
    String? hospitalId,
    String? department,
    Map<String, dynamic>? permissions,
    DateTime? lastLoginAt,
  }) {
    return User(
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
      profileImage: profileImage ?? this.profileImage,
      isActive: isActive ?? this.isActive,
      hospitalId: hospitalId ?? this.hospitalId,
      department: department ?? this.department,
      permissions: permissions ?? this.permissions,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
