import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/patient.dart';
import '../../../core/providers/patient_providers.dart';
import 'medical_records_page.dart';

class PatientPage extends ConsumerStatefulWidget {
  final String patientId;

  const PatientPage({super.key, required this.patientId});

  @override
  ConsumerState<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends ConsumerState<PatientPage>
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
    final patientsAsync = ref.watch(patientsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showPatientActions(context),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: patientsAsync.when(
        data: (patients) {
          final patient = patients.firstWhere(
            (p) => p.id == widget.patientId,
            orElse: () => throw Exception('Patient not found'),
          );

          return Column(
            children: [
              // Patient Header Card
              _buildPatientHeader(patient),

              // Tab Bar
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF2F80ED),
                  unselectedLabelColor: const Color(0xFF6B7280),
                  indicatorColor: const Color(0xFF2F80ED),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Medical Records'),
                    Tab(text: 'History'),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(patient),
                    _buildMedicalRecordsTab(patient),
                    _buildHistoryTab(patient),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF2F80ED)),
        ),
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
              Text(
                'Error loading patient',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHeader(Patient patient) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        children: [
          // Patient Avatar and Basic Info
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
                child: Text(
                  patient.initials,
                  style: const TextStyle(
                    fontSize: 24,
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
                      patient.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${patient.age} years old • ${patient.gender}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(patient.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        patient.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(patient.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildQuickStat(
                  'Blood Type',
                  patient.bloodType,
                  Icons.bloodtype,
                ),
              ),
              Expanded(
                child: _buildQuickStat(
                  'Medical Record',
                  patient.medicalRecordNumber ?? 'N/A',
                  Icons.badge,
                ),
              ),
              Expanded(
                child: _buildQuickStat(
                  'Insurance',
                  patient.insuranceProvider ?? 'N/A',
                  Icons.local_hospital,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2F80ED), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildOverviewTab(Patient patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information
          _buildInfoSection('Contact Information', Icons.contact_phone, [
            _buildInfoRow('Phone', patient.phoneNumber ?? 'Not provided'),
            _buildInfoRow('Email', patient.email ?? 'Not provided'),
            _buildInfoRow('Address', patient.fullAddress),
          ]),

          const SizedBox(height: 20),

          // Emergency Contact
          if (patient.hasEmergencyContact)
            _buildInfoSection('Emergency Contact', Icons.emergency, [
              _buildInfoRow('Name', patient.emergencyContactName!),
              _buildInfoRow('Phone', patient.emergencyContactPhone!),
              _buildInfoRow(
                'Relation',
                patient.emergencyContactRelation ?? 'Not specified',
              ),
            ]),

          const SizedBox(height: 20),

          // Medical Information
          _buildInfoSection('Medical Information', Icons.medical_services, [
            _buildInfoRow('Blood Type', patient.bloodType),
            _buildInfoRow(
              'Allergies',
              patient.allergies?.join(', ') ?? 'None reported',
            ),
            _buildInfoRow(
              'Medications',
              patient.medications?.join(', ') ?? 'None reported',
            ),
            if (patient.isOrganDonor)
              _buildInfoRow(
                'Organ Donor',
                'Yes - ${patient.donorRegistrationId ?? 'Registered'}',
              ),
          ]),

          const SizedBox(height: 20),

          // Quick Actions
          _buildQuickActions(patient),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordsTab(Patient patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Action Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2F80ED), Color(0xFF1E40AF)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2F80ED).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.folder_outlined,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Manage Medical Records',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload, view, and manage all medical documents in one place',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _viewMedicalRecords(patient),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Go to Medical Records'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2F80ED),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildMedicalActionCard(
                  'Upload Document',
                  Icons.cloud_upload_outlined,
                  'Add new medical records',
                  () => _viewMedicalRecords(patient),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMedicalActionCard(
                  'View All Records',
                  Icons.folder_open,
                  'Browse all documents',
                  () => _viewMedicalRecords(patient),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Documents Preview
          const Text(
            'Recent Documents',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          _buildDocumentsList(patient),

          const SizedBox(height: 16),

          // View All Documents Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _viewMedicalRecords(patient),
              icon: const Icon(Icons.visibility),
              label: const Text('View All Medical Records'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2F80ED),
                side: const BorderSide(color: Color(0xFF2F80ED)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(Patient patient) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Appointments
          _buildInfoSection('Recent Appointments', Icons.calendar_today, [
            _buildInfoRow('Last Visit', 'January 15, 2024'),
            _buildInfoRow('Next Appointment', 'February 20, 2024'),
            _buildInfoRow('Total Visits', '12'),
          ]),

          const SizedBox(height: 20),

          // Medical History
          if (patient.medicalHistory != null &&
              patient.medicalHistory!.isNotEmpty)
            _buildInfoSection(
              'Medical History',
              Icons.history,
              patient.medicalHistory!.entries
                  .map(
                    (entry) => _buildInfoRow(entry.key, entry.value.toString()),
                  )
                  .toList(),
            ),

          const SizedBox(height: 20),

          // Notes
          if (patient.notes != null && patient.notes!.isNotEmpty)
            _buildInfoSection('Notes', Icons.note, [
              _buildInfoRow('Medical Notes', patient.notes!),
            ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
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
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(Patient patient) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Medical Records',
                  Icons.folder_outlined,
                  () => _viewMedicalRecords(patient),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Schedule Appointment',
                  Icons.calendar_today,
                  () => _scheduleAppointment(patient),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'View Appointments',
                  Icons.list_alt,
                  () => _viewAppointments(patient),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Edit Patient',
                  Icons.edit,
                  () => _editPatient(patient),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
        foregroundColor: const Color(0xFF2F80ED),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildMedicalActionCard(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2F80ED)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList(Patient patient) {
    // Mock documents for demonstration
    final documents = [
      {'name': 'Blood Test Results', 'date': 'Jan 15, 2024', 'type': 'lab'},
      {'name': 'X-Ray Report', 'date': 'Jan 10, 2024', 'type': 'imaging'},
      {'name': 'Prescription', 'date': 'Jan 12, 2024', 'type': 'prescription'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Documents',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        ...documents.map((doc) => _buildDocumentItem(doc)),
      ],
    );
  }

  Widget _buildDocumentItem(Map<String, String> document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            _getDocumentIcon(document['type']!),
            color: const Color(0xFF2F80ED),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  document['date']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _viewDocument(document),
            icon: const Icon(Icons.visibility, size: 20),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'lab':
        return Icons.science;
      case 'imaging':
        return Icons.image;
      case 'prescription':
        return Icons.receipt;
      default:
        return Icons.description;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981);
      case 'critical':
        return const Color(0xFFEF4444);
      case 'inactive':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF2F80ED);
    }
  }

  void _showPatientActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Patient'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to edit patient page
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Schedule Appointment'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to schedule appointment
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Request Organ'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to organ request
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Patient Info'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewDocument(Map<String, String> document) {
    // TODO: Implement document viewing functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Viewing ${document['name']}')));
  }

  void _scheduleAppointment(Patient patient) {
    // TODO: Navigate to schedule appointment page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedule appointment functionality coming soon!'),
      ),
    );
  }

  void _viewAppointments(Patient patient) {
    // TODO: Navigate to appointments list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View appointments functionality coming soon!'),
      ),
    );
  }

  void _editPatient(Patient patient) {
    // TODO: Navigate to edit patient page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit patient functionality coming soon!')),
    );
  }

  void _viewMedicalRecords(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalRecordsPage(patient: patient),
      ),
    );
  }
}
