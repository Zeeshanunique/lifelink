import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment extends BaseModel {
  final String patientId;
  final String doctorId;
  final String? hospitalId;
  final DateTime scheduledDate;
  final String timeSlot;
  final String status;
  final String type;
  final String? department;
  final String? roomNumber;
  final String? notes;
  final String? diagnosis;
  final String? prescription;
  final List<String>? labTests;
  final List<String>? followUpInstructions;
  final Map<String, dynamic>? vitalSigns;
  final String? chiefComplaint;
  final String? medicalHistory;
  final String? physicalExamination;
  final String? treatmentPlan;
  final bool isEmergency;
  final int duration; // in minutes
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final DateTime? completedAt;
  final String? completedBy;
  final Map<String, dynamic>? attachments;

  // UI convenience properties
  String get title => type;
  String get patientName =>
      'Patient $patientId'; // This should be resolved from patientId
  String get doctorName =>
      'Dr. $doctorId'; // This should be resolved from doctorId
  DateTime get appointmentDate => scheduledDate;
  String get appointmentTime => timeSlot;

  const Appointment({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.patientId,
    required this.doctorId,
    this.hospitalId,
    required this.scheduledDate,
    required this.timeSlot,
    this.status = 'Scheduled',
    required this.type,
    this.department,
    this.roomNumber,
    this.notes,
    this.diagnosis,
    this.prescription,
    this.labTests,
    this.followUpInstructions,
    this.vitalSigns,
    this.chiefComplaint,
    this.medicalHistory,
    this.physicalExamination,
    this.treatmentPlan,
    this.isEmergency = false,
    this.duration = 30,
    this.cancellationReason,
    this.cancelledAt,
    this.cancelledBy,
    this.completedAt,
    this.completedBy,
    this.attachments,
  });

  bool get isCompleted => status == 'Completed';

  bool get isCancelled => status == 'Cancelled';

  bool get isScheduled => status == 'Scheduled';

  bool get isInProgress => status == 'In Progress';

  bool get isNoShow => status == 'No Show';

  bool get isPast => scheduledDate.isBefore(DateTime.now());

  bool get isToday =>
      scheduledDate.day == DateTime.now().day &&
      scheduledDate.month == DateTime.now().month &&
      scheduledDate.year == DateTime.now().year;

  bool get isUpcoming => scheduledDate.isAfter(DateTime.now());

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );

    if (appointmentDay == today) {
      return 'Today';
    } else if (appointmentDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}';
    }
  }

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);

  Appointment copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? patientId,
    String? doctorId,
    String? hospitalId,
    DateTime? scheduledDate,
    String? timeSlot,
    String? status,
    String? type,
    String? department,
    String? roomNumber,
    String? notes,
    String? diagnosis,
    String? prescription,
    List<String>? labTests,
    List<String>? followUpInstructions,
    Map<String, dynamic>? vitalSigns,
    String? chiefComplaint,
    String? medicalHistory,
    String? physicalExamination,
    String? treatmentPlan,
    bool? isEmergency,
    int? duration,
    String? cancellationReason,
    DateTime? cancelledAt,
    String? cancelledBy,
    DateTime? completedAt,
    String? completedBy,
    Map<String, dynamic>? attachments,
  }) {
    return Appointment(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      hospitalId: hospitalId ?? this.hospitalId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      type: type ?? this.type,
      department: department ?? this.department,
      roomNumber: roomNumber ?? this.roomNumber,
      notes: notes ?? this.notes,
      diagnosis: diagnosis ?? this.diagnosis,
      prescription: prescription ?? this.prescription,
      labTests: labTests ?? this.labTests,
      followUpInstructions: followUpInstructions ?? this.followUpInstructions,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      physicalExamination: physicalExamination ?? this.physicalExamination,
      treatmentPlan: treatmentPlan ?? this.treatmentPlan,
      isEmergency: isEmergency ?? this.isEmergency,
      duration: duration ?? this.duration,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      completedAt: completedAt ?? this.completedAt,
      completedBy: completedBy ?? this.completedBy,
      attachments: attachments ?? this.attachments,
    );
  }
}
