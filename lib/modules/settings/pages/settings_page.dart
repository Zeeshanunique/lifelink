import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import '../../auth/pages/login_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _emergencyAlertsEnabled = true;
  bool _donorMatchAlertsEnabled = true;
  bool _appointmentRemindersEnabled = true;
  bool _systemUpdatesEnabled = false;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  bool _autoBackupEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  final List<String> _themes = ['System', 'Light', 'Dark'];

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Info Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
                    child: Text(
                      currentUser?.initials ?? 'U',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F80ED),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser?.fullName ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          currentUser?.email ?? 'email@example.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notifications Settings
            _buildSettingsCard('Notifications', Icons.notifications_outlined, [
              _buildSwitchTile(
                'Enable Notifications',
                'Receive push notifications',
                _notificationsEnabled,
                (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              const Divider(),
              _buildSwitchTile(
                'Emergency Alerts',
                'Critical medical alerts',
                _emergencyAlertsEnabled,
                (value) {
                  setState(() {
                    _emergencyAlertsEnabled = value;
                  });
                },
                enabled: _notificationsEnabled,
              ),
              _buildSwitchTile(
                'Donor Match Alerts',
                'Compatible donor notifications',
                _donorMatchAlertsEnabled,
                (value) {
                  setState(() {
                    _donorMatchAlertsEnabled = value;
                  });
                },
                enabled: _notificationsEnabled,
              ),
              _buildSwitchTile(
                'Appointment Reminders',
                'Upcoming appointment alerts',
                _appointmentRemindersEnabled,
                (value) {
                  setState(() {
                    _appointmentRemindersEnabled = value;
                  });
                },
                enabled: _notificationsEnabled,
              ),
              _buildSwitchTile(
                'System Updates',
                'App updates and maintenance',
                _systemUpdatesEnabled,
                (value) {
                  setState(() {
                    _systemUpdatesEnabled = value;
                  });
                },
                enabled: _notificationsEnabled,
              ),
            ]),

            const SizedBox(height: 16),

            // Appearance Settings
            _buildSettingsCard('Appearance', Icons.palette_outlined, [
              _buildDropdownTile(
                'Theme',
                'Choose app theme',
                _selectedTheme,
                _themes,
                (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                },
              ),
              const Divider(),
              _buildSwitchTile(
                'Dark Mode',
                'Use dark theme',
                _darkModeEnabled,
                (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
              _buildDropdownTile(
                'Language',
                'Select app language',
                _selectedLanguage,
                _languages,
                (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
            ]),

            const SizedBox(height: 16),

            // Security Settings
            _buildSettingsCard('Security', Icons.security_outlined, [
              _buildSwitchTile(
                'Biometric Login',
                'Use fingerprint or face ID',
                _biometricEnabled,
                (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
              const Divider(),
              _buildActionTile(
                'Change Password',
                'Update your account password',
                Icons.lock_outline,
                () => _showChangePasswordDialog(),
              ),
              _buildActionTile(
                'Two-Factor Authentication',
                'Add an extra layer of security',
                Icons.verified_user_outlined,
                () => _show2FADialog(),
              ),
              _buildActionTile(
                'Active Sessions',
                'Manage logged-in devices',
                Icons.devices_outlined,
                () => _showActiveSessionsDialog(),
              ),
            ]),

            const SizedBox(height: 16),

            // Data & Privacy Settings
            _buildSettingsCard('Data & Privacy', Icons.privacy_tip_outlined, [
              _buildSwitchTile(
                'Auto Backup',
                'Backup data automatically',
                _autoBackupEnabled,
                (value) {
                  setState(() {
                    _autoBackupEnabled = value;
                  });
                },
              ),
              const Divider(),
              _buildActionTile(
                'Download My Data',
                'Export your personal data',
                Icons.download_outlined,
                () => _downloadData(),
              ),
              _buildActionTile(
                'Privacy Settings',
                'Manage data sharing preferences',
                Icons.shield_outlined,
                () => _showPrivacyDialog(),
              ),
              _buildActionTile(
                'Clear Cache',
                'Free up storage space',
                Icons.cleaning_services_outlined,
                () => _clearCache(),
              ),
            ]),

            const SizedBox(height: 16),

            // Support Settings
            _buildSettingsCard('Support', Icons.help_outline, [
              _buildActionTile(
                'Help Center',
                'Get help and support',
                Icons.help_center_outlined,
                () => _openHelpCenter(),
              ),
              _buildActionTile(
                'Contact Support',
                'Reach out to our team',
                Icons.support_agent_outlined,
                () => _contactSupport(),
              ),
              _buildActionTile(
                'Report a Bug',
                'Help us improve the app',
                Icons.bug_report_outlined,
                () => _reportBug(),
              ),
              _buildActionTile(
                'Rate the App',
                'Share your feedback',
                Icons.star_outline,
                () => _rateApp(),
              ),
            ]),

            const SizedBox(height: 16),

            // About Settings
            _buildSettingsCard('About', Icons.info_outline, [
              _buildInfoTile('Version', '1.0.0'),
              _buildInfoTile('Build', '2024.1.1'),
              const Divider(),
              _buildActionTile(
                'Terms of Service',
                'Read our terms',
                Icons.description_outlined,
                () => _showTerms(),
              ),
              _buildActionTile(
                'Privacy Policy',
                'View privacy policy',
                Icons.policy_outlined,
                () => _showPrivacyPolicy(),
              ),
              _buildActionTile(
                'Open Source Licenses',
                'Third-party licenses',
                Icons.code_outlined,
                () => _showLicenses(),
              ),
            ]),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2F80ED), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: enabled ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: enabled ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
        ),
      ),
      trailing: Switch(
        value: enabled ? value : false,
        onChanged: enabled ? onChanged : null,
        activeColor: const Color(0xFF2F80ED),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
      ),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map((option) {
          return DropdownMenuItem(value: option, child: Text(option));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF6B7280)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text(
          'This feature will redirect you to password reset.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset email sent!')),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _show2FADialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text('2FA setup will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('Current Device'),
              subtitle: Text('Last active: Now'),
            ),
            ListTile(
              leading: Icon(Icons.computer),
              title: Text('Web Browser'),
              subtitle: Text('Last active: 2 hours ago'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _downloadData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data export initiated. You will receive an email shortly.',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: const Text('Advanced privacy settings coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening help center...')));
  }

  void _contactSupport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Redirecting to support...')));
  }

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bug report form will open...')),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecting to app store...')),
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const Text(
          'Terms of service content would be displayed here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy policy content would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicenses() {
    showLicensePage(context: context);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Simple logout without complex UI
              try {
                // Clear current user from state immediately
                ref.read(currentUserProvider.notifier).clearUser();

                // Call logout service
                await ref.read(authServiceProvider).logout();

                // Navigate to login page
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              } catch (e) {
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
