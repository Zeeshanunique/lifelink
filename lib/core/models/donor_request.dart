import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'donor_request.g.dart';

enum RequestStatus { pending, approved, rejected, matched, completed, cancelled }
enum RequestUrgency { low, medium, high, critical }

@JsonSerializable()
class DonorRequest extends BaseModel {
  final String patientId;
  final String hospitalId;
  final String requestingDoctorId;
  final List<String> organsNeeded;
  final String bloodType;
  final RequestUrgency urgency;
  final RequestStatus status;
  final String medicalReason;
  final Map<String, dynamic> medicalRequirements;
  final DateTime neededBy;
  final String? notes;
  final List<String>? matchedDonorIds;
  final String? selectedDonorId;
  final DateTime? matchedAt;
  final DateTime? completedAt;
  final String? rejectionReason;
  final Map<String, dynamic>? compatibility;

  const DonorRequest({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.patientId,
    required this.hospitalId,
    required this.requestingDoctorId,
    required this.organsNeeded,
    required this.bloodType,
    required this.urgency,
    this.status = RequestStatus.pending,
    required this.medicalReason,
    required this.medicalRequirements,
    required this.neededBy,
    this.notes,
    this.matchedDonorIds,
    this.selectedDonorId,
    this.matchedAt,
    this.completedAt,
    this.rejectionReason,
    this.compatibility,
  });

  bool get isPending => status == RequestStatus.pending;
  bool get isApproved => status == RequestStatus.approved;
  bool get isMatched => status == RequestStatus.matched;
  bool get isCompleted => status == RequestStatus.completed;
  bool get isCritical => urgency == RequestUrgency.critical;
  bool get isOverdue => DateTime.now().isAfter(neededBy);

  String get statusString {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.matched:
        return 'Matched';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get urgencyString {
    switch (urgency) {
      case RequestUrgency.low:
        return 'Low';
      case RequestUrgency.medium:
        return 'Medium';
      case RequestUrgency.high:
        return 'High';
      case RequestUrgency.critical:
        return 'Critical';
    }
  }

  int get daysUntilNeeded => neededBy.difference(DateTime.now()).inDays;

  factory DonorRequest.fromJson(Map<String, dynamic> json) =>
      _$DonorRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DonorRequestToJson(this);

  DonorRequest copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? patientId,
    String? hospitalId,
    String? requestingDoctorId,
    List<String>? organsNeeded,
    String? bloodType,
    RequestUrgency? urgency,
    RequestStatus? status,
    String? medicalReason,
    Map<String, dynamic>? medicalRequirements,
    DateTime? neededBy,
    String? notes,
    List<String>? matchedDonorIds,
    String? selectedDonorId,
    DateTime? matchedAt,
    DateTime? completedAt,
    String? rejectionReason,
    Map<String, dynamic>? compatibility,
  }) {
    return DonorRequest(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      patientId: patientId ?? this.patientId,
      hospitalId: hospitalId ?? this.hospitalId,
      requestingDoctorId: requestingDoctorId ?? this.requestingDoctorId,
      organsNeeded: organsNeeded ?? this.organsNeeded,
      bloodType: bloodType ?? this.bloodType,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
      medicalReason: medicalReason ?? this.medicalReason,
      medicalRequirements: medicalRequirements ?? this.medicalRequirements,
      neededBy: neededBy ?? this.neededBy,
      notes: notes ?? this.notes,
      matchedDonorIds: matchedDonorIds ?? this.matchedDonorIds,
      selectedDonorId: selectedDonorId ?? this.selectedDonorId,
      matchedAt: matchedAt ?? this.matchedAt,
      completedAt: completedAt ?? this.completedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      compatibility: compatibility ?? this.compatibility,
    );
  }
}