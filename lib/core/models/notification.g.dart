// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      priority:
          $enumDecodeNullable(
            _$NotificationPriorityEnumMap,
            json['priority'],
          ) ??
          NotificationPriority.medium,
      recipientId: json['recipientId'] as String,
      senderId: json['senderId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      data: json['data'] as Map<String, dynamic>?,
      actionUrl: json['actionUrl'] as String?,
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.parse(json['scheduledFor'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'recipientId': instance.recipientId,
      'senderId': instance.senderId,
      'isRead': instance.isRead,
      'isArchived': instance.isArchived,
      'readAt': instance.readAt?.toIso8601String(),
      'data': instance.data,
      'actionUrl': instance.actionUrl,
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.donorMatch: 'donorMatch',
  NotificationType.appointmentReminder: 'appointmentReminder',
  NotificationType.emergencyAlert: 'emergencyAlert',
  NotificationType.systemUpdate: 'systemUpdate',
  NotificationType.donorRequest: 'donorRequest',
  NotificationType.transplantUpdate: 'transplantUpdate',
  NotificationType.medicalAlert: 'medicalAlert',
  NotificationType.general: 'general',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.medium: 'medium',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};
