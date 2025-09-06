import 'package:flutter/material.dart';
import '../../../core/models/organ_donor.dart';

class DonorDetailsPage extends StatelessWidget {
  final OrganDonor donor;

  const DonorDetailsPage({super.key, required this.donor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(donor.fullName),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donor Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: _getStatusColor().withOpacity(0.1),
                          child: Text(
                            donor.initials,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                donor.fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${donor.age} years • ${donor.bloodType}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  donor.status,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Address', donor.fullAddress),
                    _buildInfoRow('Phone', donor.phoneNumber ?? 'Not provided'),
                    _buildInfoRow('Email', donor.email ?? 'Not provided'),
                    if (donor.hasEmergencyContact) ...[
                      _buildInfoRow(
                        'Emergency Contact',
                        donor.emergencyContactName!,
                      ),
                      _buildInfoRow(
                        'Emergency Phone',
                        donor.emergencyContactPhone!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Organs to Donate Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organs to Donate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (donor.organsToDonate.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: donor.organsToDonate.map((organ) {
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
                              organ,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      const Text(
                        'No organs selected for donation',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Health Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Health Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Blood Type', donor.bloodType),
                    _buildInfoRow(
                      'Health Status',
                      donor.healthStatus ?? 'Not specified',
                    ),
                    if (donor.lastHealthCheck != null)
                      _buildInfoRow(
                        'Last Health Check',
                        _formatDate(donor.lastHealthCheck!),
                      ),
                    if (donor.allergies != null &&
                        donor.allergies!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Allergies:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        donor.allergies!.join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Registration Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registration Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (donor.registrationDate != null)
                      _buildInfoRow(
                        'Registration Date',
                        _formatDate(donor.registrationDate!),
                      ),
                    if (donor.lastUpdated != null)
                      _buildInfoRow(
                        'Last Updated',
                        _formatDate(donor.lastUpdated!),
                      ),
                    _buildInfoRow('Donor ID', donor.id),
                    if (donor.patientId.isNotEmpty)
                      _buildInfoRow('Patient ID', donor.patientId),
                  ],
                ),
              ),
            ),

            // Special Status Cards
            if (donor.isDeceased) ...[
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFFFEF2F2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Color(0xFFEF4444),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deceased Donor',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                            if (donor.deathDate != null)
                              Text(
                                'Date of Death: ${_formatDate(donor.deathDate!)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            if (donor.causeOfDeath != null)
                              Text(
                                'Cause: ${donor.causeOfDeath}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (donor.isTransplanted) ...[
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFFF0FDF4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Successfully Transplanted',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            if (donor.transplantDate != null)
                              Text(
                                'Transplant Date: ${_formatDate(donor.transplantDate!)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            if (donor.transplantHospitalId != null)
                              Text(
                                'Hospital ID: ${donor.transplantHospitalId}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            width: 120,
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

  Color _getStatusColor() {
    switch (donor.status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'registered':
        return const Color(0xFF2D7CFF);
      case 'deceased':
        return const Color(0xFFEF4444);
      case 'transplanted':
        return const Color(0xFF8B5CF6);
      case 'inactive':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
