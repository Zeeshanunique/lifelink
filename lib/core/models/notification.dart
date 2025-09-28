import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'notification.g.dart';

enum NotificationType {
  donorMatch,
  appointmentReminder,
  emergencyAlert,
  systemUpdate,
  donorRequest,
  transplantUpdate,
  medicalAlert,
  general
}

enum NotificationPriority { low, medium, high, urgent }

@JsonSerializable()
class AppNotification extends BaseModel {
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final String recipientId;
  final String? senderId;
  final bool isRead;
  final bool isArchived;
  final DateTime? readAt;
  final Map<String, dynamic>? data;
  final String? actionUrl;
  final DateTime? scheduledFor;

  const AppNotification({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.medium,
    required this.recipientId,
    this.senderId,
    this.isRead = false,
    this.isArchived = false,
    this.readAt,
    this.data,
    this.actionUrl,
    this.scheduledFor,
  });

  bool get isUnread => !isRead;
  bool get isUrgent => priority == NotificationPriority.urgent;
  bool get isScheduled => scheduledFor != null && scheduledFor!.isAfter(DateTime.now());

  String get priorityString {
    switch (priority) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.medium:
        return 'Medium';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  String get typeString {
    switch (type) {
      case NotificationType.donorMatch:
        return 'Donor Match';
      case NotificationType.appointmentReminder:
        return 'Appointment Reminder';
      case NotificationType.emergencyAlert:
        return 'Emergency Alert';
      case NotificationType.systemUpdate:
        return 'System Update';
      case NotificationType.donorRequest:
        return 'Donor Request';
      case NotificationType.transplantUpdate:
        return 'Transplant Update';
      case NotificationType.medicalAlert:
        return 'Medical Alert';
      case NotificationType.general:
        return 'General';
    }
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  AppNotification copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    String? recipientId,
    String? senderId,
    bool? isRead,
    bool? isArchived,
    DateTime? readAt,
    Map<String, dynamic>? data,
    String? actionUrl,
    DateTime? scheduledFor,
  }) {
    return AppNotification(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      readAt: readAt ?? this.readAt,
      data: data ?? this.data,
      actionUrl: actionUrl ?? this.actionUrl,
      scheduledFor: scheduledFor ?? this.scheduledFor,
    );
  }
}