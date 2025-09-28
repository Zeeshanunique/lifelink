import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/models/auth_user.dart';
import '../../core/providers/notification_providers.dart';
import '../../core/utils/rbac_utils.dart';
import '../home/pages/modular_home_page.dart';
import '../hospital_management/pages/hospital_list_page.dart';
import '../organ_donor_management/pages/donor_list_page.dart';
import '../patient_management/pages/patient_list_page.dart';
import '../appointment_management/pages/appointment_list_page.dart';
import '../analytics/pages/analytics_dashboard.dart';
import '../donor_matching/pages/donor_matching_page.dart';

class ModularNavigationPage extends ConsumerStatefulWidget {
  const ModularNavigationPage({super.key});

  @override
  ConsumerState<ModularNavigationPage> createState() =>
      _ModularNavigationPageState();
}

class _ModularNavigationPageState extends ConsumerState<ModularNavigationPage> {
  int _currentIndex = 0;

  List<Widget> _buildPages(UserRole? role) {
    // Default pages for safety
    List<Widget> pages = [const ModularHomePage(), const DonorListPage()];

    switch (role) {
      case UserRole.patient:
        pages = [
          const ModularHomePage(),
          const DonorListPage(),
          const DonorMatchingPage(),
        ];
        break;
      case UserRole.hospital:
        pages = [
          const ModularHomePage(),
          const HospitalListPage(),
          const PatientListPage(),
          const AppointmentListPage(),
          const DonorMatchingPage(),
        ];
        break;
      case UserRole.admin:
        pages = [
          const ModularHomePage(),
          const HospitalListPage(),
          const DonorListPage(),
          const AnalyticsDashboard(),
        ];
        break;
      default:
        pages = [const ModularHomePage(), const DonorListPage()];
    }
    return pages;
  }

  List<BottomNavigationBarItem> _buildNavItems(UserRole? role) {
    switch (role) {
      case UserRole.patient:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline, size: 24),
            activeIcon: Icon(Icons.favorite, size: 24),
            label: 'Donors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined, size: 24),
            activeIcon: Icon(Icons.search, size: 24),
            label: 'Matching',
          ),
        ];
      case UserRole.hospital:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_outlined, size: 24),
            activeIcon: Icon(Icons.local_hospital, size: 24),
            label: 'Hospitals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: 24),
            activeIcon: Icon(Icons.people, size: 24),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined, size: 24),
            activeIcon: Icon(Icons.event_note, size: 24),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined, size: 24),
            activeIcon: Icon(Icons.search, size: 24),
            label: 'Matching',
          ),
        ];
      case UserRole.admin:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_outlined, size: 24),
            activeIcon: Icon(Icons.local_hospital, size: 24),
            label: 'Hospitals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline, size: 24),
            activeIcon: Icon(Icons.favorite, size: 24),
            label: 'Donors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined, size: 24),
            activeIcon: Icon(Icons.analytics, size: 24),
            label: 'Analytics',
          ),
        ];
      default:
        return const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24),
            activeIcon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline, size: 24),
            activeIcon: Icon(Icons.favorite, size: 24),
            label: 'Donors',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final role = currentUser?.role;
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);
    final pages = _buildPages(role);
    final items = _buildNavItems(role);

    // Ensure at least 2 items/pages during transient states (e.g., logout)
    final paddedPages = List<Widget>.from(pages);
    final paddedItems = List<BottomNavigationBarItem>.from(items);
    while (paddedItems.length < 2) {
      paddedItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 24),
          activeIcon: Icon(Icons.home, size: 24),
          label: 'Home',
        ),
      );
    }
    while (paddedPages.length < 2) {
      paddedPages.add(const ModularHomePage());
    }

    // Keep index within bounds if role changed
    if (_currentIndex >= paddedPages.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      appBar: _currentIndex == 0
          ? _buildAppBar(context, unreadCountAsync)
          : null,
      body: IndexedStack(index: _currentIndex, children: paddedPages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2F80ED),
          unselectedItemColor: const Color(0xFF9CA3AF),
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: paddedItems,
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(
    BuildContext context,
    AsyncValue<int> unreadCountAsync,
  ) {
    final currentUser = ref.watch(currentUserProvider);

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LifeLink',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (currentUser != null)
            Text(
              'Welcome back, ${currentUser.firstName}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF6B7280),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Notifications
        Stack(
          children: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
              icon: const Icon(Icons.notifications_outlined),
            ),
            unreadCountAsync.when(
              data: (count) => count > 0
                  ? Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),

        // User Profile Menu
        PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
            child: Text(
              currentUser?.initials ?? 'U',
              style: const TextStyle(
                color: Color(0xFF2F80ED),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'patients',
              child: Row(
                children: [
                  Icon(Icons.people_outline, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  const Text('Patients'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'appointments',
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  const Text('Appointments'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  const Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20, color: Colors.red[600]),
                  const SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.red[600])),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'patients':
        Navigator.pushNamed(context, '/patients');
        break;
      case 'appointments':
        Navigator.pushNamed(context, '/appointments');
        break;
      case 'settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).logout();
              ref.read(currentUserProvider.notifier).clearUser();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
