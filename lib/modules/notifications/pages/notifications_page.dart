import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/notification.dart';
import '../../../core/providers/notification_providers.dart';
import '../widgets/notification_card.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_read',
                child: Text('Clear read notifications'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Notification settings'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2F80ED),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF2F80ED),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
            Tab(text: 'Important'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(NotificationFilter.all),
          _buildNotificationsList(NotificationFilter.unread),
          _buildNotificationsList(NotificationFilter.important),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(NotificationFilter filter) {
    final notificationsAsync = ref.watch(notificationsProvider(filter));

    return notificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getEmptyStateIcon(filter),
                  size: 64,
                  color: const Color(0xFF9CA3AF),
                ),
                const SizedBox(height: 16),
                Text(
                  _getEmptyStateMessage(filter),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getEmptyStateSubtitle(filter),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NotificationCard(
                notification: notification,
                onTap: () => _handleNotificationTap(notification),
                onDismiss: () => _dismissNotification(notification),
                onMarkAsRead: () => _markAsRead(notification),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(notificationsProvider(filter));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEmptyStateIcon(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return Icons.notifications_none;
      case NotificationFilter.unread:
        return Icons.mark_email_read_outlined;
      case NotificationFilter.important:
        return Icons.priority_high;
    }
  }

  String _getEmptyStateMessage(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return 'No notifications';
      case NotificationFilter.unread:
        return 'All caught up!';
      case NotificationFilter.important:
        return 'No urgent notifications';
    }
  }

  String _getEmptyStateSubtitle(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return 'You don\'t have any notifications yet.\nWe\'ll notify you when something important happens.';
      case NotificationFilter.unread:
        return 'You\'ve read all your notifications.\nGreat job staying on top of things!';
      case NotificationFilter.important:
        return 'No urgent matters require your attention at this time.';
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    if (notification.isUnread) {
      _markAsRead(notification);
    }
    
    // Handle navigation based on notification type
    if (notification.actionUrl != null) {
      // Navigate to specific page based on actionUrl
      _navigateToNotificationTarget(notification);
    } else {
      // Show notification details
      _showNotificationDetails(notification);
    }
  }

  void _navigateToNotificationTarget(AppNotification notification) {
    final actionUrl = notification.actionUrl!;
    
    if (actionUrl.startsWith('/donor-match/')) {
      // Navigate to donor matching page
      Navigator.pushNamed(context, '/donor-match');
    } else if (actionUrl.startsWith('/appointment/')) {
      // Navigate to appointment details
      Navigator.pushNamed(context, '/appointments');
    } else if (actionUrl.startsWith('/hospital/')) {
      // Navigate to hospital details
      Navigator.pushNamed(context, '/hospitals');
    } else {
      // Default action
      _showNotificationDetails(notification);
    }
  }

  void _showNotificationDetails(AppNotification notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notification.typeString,
                  style: TextStyle(
                    fontSize: 14,
                    color: _getNotificationColor(notification.type),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notification.message,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Received: ${_formatDateTime(notification.createdAt)}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            if (notification.actionUrl != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToNotificationTarget(notification);
                  },
                  child: const Text('View Details'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.donorMatch:
        return const Color(0xFF10B981);
      case NotificationType.emergencyAlert:
        return const Color(0xFFEF4444);
      case NotificationType.appointmentReminder:
        return const Color(0xFF3B82F6);
      case NotificationType.transplantUpdate:
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _markAsRead(AppNotification notification) {
    ref.read(notificationServiceProvider).markAsRead(notification.id);
  }

  void _markAllAsRead() {
    ref.read(notificationServiceProvider).markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _dismissNotification(AppNotification notification) {
    ref.read(notificationServiceProvider).dismiss(notification.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification dismissed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear_read':
        ref.read(notificationServiceProvider).clearReadNotifications();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Read notifications cleared')),
        );
        break;
      case 'settings':
        Navigator.pushNamed(context, '/notification-settings');
        break;
    }
  }
}

enum NotificationFilter { all, unread, important }