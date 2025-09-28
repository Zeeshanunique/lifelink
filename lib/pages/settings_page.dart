import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/auth_providers.dart';
import '../modules/auth/pages/login_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _biometric = false;

  Future<void> _handleLogout() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call logout service
      final authService = ref.read(authServiceProvider);
      final result = await authService.logout();

      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      result.when(
        success: (_) {
          // Clear current user from state
          ref.read(currentUserProvider.notifier).clearUser();

          // Navigate to login page
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        failure: (failure) {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      // Close loading indicator if still showing
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Area
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time
                  const Text(
                    '9:41',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  // Status Icons
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Container(height: 1, color: const Color(0xFFF3F4F6)),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Settings Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const Row(
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Settings Sections
                    _buildSettingsSection('General', [
                      _buildSwitchSetting(
                        'Dark Mode',
                        'Switch to dark theme',
                        Icons.dark_mode_outlined,
                        _darkMode,
                        (value) => setState(() => _darkMode = value),
                      ),
                      _buildSwitchSetting(
                        'Notifications',
                        'Receive push notifications',
                        Icons.notifications_outlined,
                        _notifications,
                        (value) => setState(() => _notifications = value),
                      ),
                      _buildSwitchSetting(
                        'Biometric Login',
                        'Use fingerprint or face ID',
                        Icons.fingerprint_outlined,
                        _biometric,
                        (value) => setState(() => _biometric = value),
                      ),
                      _buildListSetting(
                        'Language',
                        'English',
                        Icons.language_outlined,
                        () {},
                      ),
                      _buildListSetting(
                        'Theme',
                        'System Default',
                        Icons.palette_outlined,
                        () {},
                      ),
                    ]),

                    _buildSettingsSection('Account', [
                      _buildListSetting(
                        'Edit Profile',
                        'Update your information',
                        Icons.person_outline,
                        () {},
                      ),
                      _buildListSetting(
                        'Change Password',
                        'Update your password',
                        Icons.lock_outline,
                        () {},
                      ),
                      _buildListSetting(
                        'Two-Factor Auth',
                        'Add extra security',
                        Icons.security_outlined,
                        () {},
                      ),
                    ]),

                    _buildSettingsSection('Privacy & Security', [
                      _buildListSetting(
                        'Privacy Policy',
                        'Read our privacy policy',
                        Icons.privacy_tip_outlined,
                        () {},
                      ),
                      _buildListSetting(
                        'Terms of Service',
                        'Read our terms',
                        Icons.description_outlined,
                        () {},
                      ),
                      _buildListSetting(
                        'Data & Privacy',
                        'Manage your data',
                        Icons.shield_outlined,
                        () {},
                      ),
                    ]),

                    _buildSettingsSection('Support', [
                      _buildListSetting(
                        'Help Center',
                        'Get help and support',
                        Icons.help_outline,
                        () {},
                      ),
                      _buildListSetting(
                        'Contact Us',
                        'Send us feedback',
                        Icons.email_outlined,
                        () {},
                      ),
                      _buildListSetting(
                        'About',
                        'App version 1.0.0',
                        Icons.info_outline,
                        () {},
                      ),
                    ]),

                    // Logout Button
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2F80ED).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2F80ED), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2F80ED),
        ),
      ),
    );
  }

  Widget _buildListSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2F80ED).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2F80ED), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF9CA3AF),
        ),
        onTap: onTap,
      ),
    );
  }
}
