import '../models/notification.dart';
import '../utils/result.dart';
import '../errors/failures.dart';

abstract class NotificationService {
  Future<Result<List<AppNotification>>> getNotifications();
  Future<Result<List<AppNotification>>> getUnreadNotifications();
  Future<Result<List<AppNotification>>> getNotificationsByType(NotificationType type);
  Future<Result<AppNotification>> markAsRead(String notificationId);
  Future<Result<void>> markAllAsRead();
  Future<Result<void>> dismiss(String notificationId);
  Future<Result<void>> clearReadNotifications();
  Future<Result<AppNotification>> createNotification(AppNotification notification);
  Future<int> getUnreadCount();
}

class MockNotificationService implements NotificationService {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'notif_1',
      title: 'New Donor Match Found!',
      message: 'A compatible donor has been found for your heart transplant request. Match compatibility: 95%',
      type: NotificationType.donorMatch,
      priority: NotificationPriority.urgent,
      recipientId: 'user_1',
      senderId: 'system',
      isRead: false,
      actionUrl: '/donor-match/123',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Appointment Reminder',
      message: 'You have an appointment scheduled for tomorrow at 10:00 AM with Dr. Johnson.',
      type: NotificationType.appointmentReminder,
      priority: NotificationPriority.high,
      recipientId: 'user_1',
      senderId: 'system',
      isRead: false,
      actionUrl: '/appointment/456',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: 'notif_3',
      title: 'Emergency Alert: Blood Needed',
      message: 'Urgent: O+ blood needed at City General Hospital for emergency surgery.',
      type: NotificationType.emergencyAlert,
      priority: NotificationPriority.urgent,
      recipientId: 'user_1',
      senderId: 'hospital_1',
      isRead: true,
      readAt: DateTime.now().subtract(const Duration(hours: 1)),
      actionUrl: '/emergency/789',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      id: 'notif_4',
      title: 'Donor Request Approved',
      message: 'Your organ donation request has been approved and added to the registry.',
      type: NotificationType.donorRequest,
      priority: NotificationPriority.medium,
      recipientId: 'user_1',
      senderId: 'admin_1',
      isRead: true,
      readAt: DateTime.now().subtract(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AppNotification(
      id: 'notif_5',
      title: 'System Maintenance',
      message: 'The system will be under maintenance from 2:00 AM to 4:00 AM tomorrow.',
      type: NotificationType.systemUpdate,
      priority: NotificationPriority.low,
      recipientId: 'user_1',
      senderId: 'system',
      isRead: false,
      scheduledFor: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  @override
  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Sort by creation date (newest first)
      final sortedNotifications = List<AppNotification>.from(_notifications);
      sortedNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return Result.success(sortedNotifications);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch notifications: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<AppNotification>>> getUnreadNotifications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final unreadNotifications = _notifications.where((n) => !n.isRead).toList();
      unreadNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return Result.success(unreadNotifications);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch unread notifications: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<AppNotification>>> getNotificationsByType(NotificationType type) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final filteredNotifications = _notifications.where((n) => n.type == type).toList();
      filteredNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return Result.success(filteredNotifications);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch notifications by type: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppNotification>> markAsRead(String notificationId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index == -1) {
        return Result.failure(ServerFailure('Notification not found'));
      }

      final updatedNotification = _notifications[index].copyWith(
        isRead: true,
        readAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _notifications[index] = updatedNotification;
      return Result.success(updatedNotification);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to mark notification as read: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead) {
          _notifications[i] = _notifications[i].copyWith(
            isRead: true,
            readAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }
      
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to mark all notifications as read: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> dismiss(String notificationId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      _notifications.removeWhere((n) => n.id == notificationId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to dismiss notification: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> clearReadNotifications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      _notifications.removeWhere((n) => n.isRead);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to clear read notifications: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppNotification>> createNotification(AppNotification notification) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final newNotification = notification.copyWith(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _notifications.insert(0, newNotification);
      return Result.success(newNotification);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to create notification: ${e.toString()}'));
    }
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notifications.where((n) => !n.isRead).length;
  }
}