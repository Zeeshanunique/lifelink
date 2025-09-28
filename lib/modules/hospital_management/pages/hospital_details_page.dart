import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/hospital.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/models/auth_user.dart';

class HospitalDetailsPage extends ConsumerWidget {
  final Hospital hospital;

  const HospitalDetailsPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(hospital.name),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Actions (Approve / Decline) - visible only to Admin
            if (ref.watch(userRoleProvider) == UserRole.admin)
              _AdminApprovalBar(hospital: hospital),
            const SizedBox(height: 12),

            // Hospital Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hospital Information',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Type', hospital.type),
                    _buildInfoRow('Address', hospital.fullAddress),
                    _buildInfoRow(
                      'Phone',
                      hospital.phoneNumber ?? 'Not provided',
                    ),
                    _buildInfoRow('Email', hospital.email ?? 'Not provided'),
                    _buildInfoRow(
                      'Website',
                      hospital.website ?? 'Not provided',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Statistics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Beds',
                            hospital.totalBeds.toString(),
                            Icons.bed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'ICU Beds',
                            hospital.icuBeds.toString(),
                            Icons.medical_services,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Emergency Beds',
                            hospital.emergencyBeds.toString(),
                            Icons.emergency,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Specialties',
                            hospital.specialties.length.toString(),
                            Icons.medical_information,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Specialties Card
            if (hospital.specialties.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specialties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hospital.specialties.map((specialty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D7CFF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              specialty,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2D7CFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Services Card
            if (hospital.services.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hospital.services.map((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              service,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2D7CFF), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D7CFF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AdminApprovalBar extends StatelessWidget {
  final Hospital hospital;
  const _AdminApprovalBar({required this.hospital});

  @override
  Widget build(BuildContext context) {
    // Simple role gate via snackbar prompt; in a full app we'd read current user role.
    void notAdminGuard(VoidCallback action) {
      // Placeholder: Always allow for now. Replace with role check if available.
      action();
    }

    return Card(
      color: const Color(0xFFFFFBEB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFFDE68A)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: Color(0xFF92400E)),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Admin Review: Approve or decline hospital onboarding request.',
                style: TextStyle(color: Color(0xFF92400E)),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                notAdminGuard(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Approved ${hospital.name}')),
                  );
                });
              },
              icon: const Icon(Icons.check_circle, color: Colors.green),
              label: const Text('Approve'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                notAdminGuard(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Declined ${hospital.name}')),
                  );
                });
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
              label: const Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}
