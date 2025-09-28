import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return MockNotificationService();
});

// All Notifications Provider
final notificationsProvider =
    FutureProvider.family<List<AppNotification>, dynamic>((ref, filter) async {
      final service = ref.watch(notificationServiceProvider);
      final result = await service.getNotifications();
      return result.when(
        success: (notifications) => notifications,
        failure: (failure) => <AppNotification>[],
      );
    });

// Unread Count Provider
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.getUnreadCount();
});

// Recent Notifications Provider (for dashboard/home)
final recentNotificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  final service = ref.watch(notificationServiceProvider);
  final result = await service.getNotifications();
  return result.when(
    success: (notifications) => notifications.take(5).toList(),
    failure: (failure) => <AppNotification>[],
  );
});
