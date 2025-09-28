import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/patient.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/models/auth_user.dart';

class PatientDetailsPage extends ConsumerStatefulWidget {
  final Patient patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  ConsumerState<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends ConsumerState<PatientDetailsPage> {
  final List<_PatientDocument> _documents = <_PatientDocument>[];
  bool _requestSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('${widget.patient.firstName} ${widget.patient.lastName}'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement edit patient functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit functionality coming soon!'),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Card
            _buildPatientHeaderCard(),
            const SizedBox(height: 16),

            // Personal Information
            _buildInfoSection('Personal Information', [
              _buildInfoRow('First Name', widget.patient.firstName),
              _buildInfoRow('Last Name', widget.patient.lastName),
              _buildInfoRow('Email', widget.patient.email ?? 'N/A'),
              _buildInfoRow('Phone', widget.patient.phoneNumber ?? 'N/A'),
              _buildInfoRow(
                'Date of Birth',
                '${widget.patient.dateOfBirth.day}/${widget.patient.dateOfBirth.month}/${widget.patient.dateOfBirth.year}',
              ),
              _buildInfoRow('Gender', widget.patient.gender),
              _buildInfoRow('Blood Type', widget.patient.bloodType),
              _buildInfoRow('Status', widget.patient.status),
            ]),
            const SizedBox(height: 16),

            // Address Information
            _buildInfoSection('Address Information', [
              _buildInfoRow('Address', widget.patient.address),
              _buildInfoRow('City', widget.patient.city),
              _buildInfoRow('State', widget.patient.state),
              _buildInfoRow('ZIP Code', widget.patient.zipCode ?? 'N/A'),
            ]),
            const SizedBox(height: 16),

            // Emergency Contact
            _buildInfoSection('Emergency Contact', [
              _buildInfoRow(
                'Name',
                widget.patient.emergencyContactName ?? 'N/A',
              ),
              _buildInfoRow(
                'Phone',
                widget.patient.emergencyContactPhone ?? 'N/A',
              ),
            ]),
            const SizedBox(height: 16),

            // Medical Information
            _buildInfoSection('Medical Information', [
              _buildInfoRow(
                'Medical Record Number',
                widget.patient.medicalRecordNumber ?? 'N/A',
              ),
              _buildInfoRow(
                'Insurance Provider',
                widget.patient.insuranceProvider ?? 'N/A',
              ),
              if (widget.patient.notes?.isNotEmpty ?? false)
                _buildInfoRow('Notes', widget.patient.notes!),
            ]),
            const SizedBox(height: 16),

            // Patient Actions (visible only to Patient role)
            if (ref.watch(userRoleProvider) == UserRole.patient)
              _buildPatientActions(context),
            const SizedBox(height: 16),

            // Uploaded Documents (summary)
            if (_documents.isNotEmpty)
              _buildInfoSection(
                'Uploaded Documents',
                _documents.map((d) => _buildInfoRow(d.type, d.note)).toList(),
              ),

            // Medical History (Placeholder)
            _buildInfoSection('Medical History', [
              _buildInfoRow('Last Visit', 'Not available'),
              _buildInfoRow('Next Appointment', 'Not scheduled'),
              _buildInfoRow('Allergies', 'None recorded'),
              _buildInfoRow('Medications', 'None recorded'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeaderCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
              child: Text(
                '${widget.patient.firstName[0]}${widget.patient.lastName[0]}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF2F80ED),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Patient Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.patient.firstName} ${widget.patient.lastName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient ID: ${widget.patient.id}',
                    style: const TextStyle(
                      fontSize: 14,
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
                      color: _getStatusColor(
                        widget.patient.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.patient.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(widget.patient.status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Age
            Column(
              children: [
                Text(
                  '${_calculateAge(widget.patient.dateOfBirth)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F80ED),
                  ),
                ),
                const Text(
                  'years old',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
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
              value.isEmpty ? 'Not provided' : value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientActions(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Upload Documents',
                    Icons.upload_file,
                    _handleUploadDocuments,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    context,
                    _requestSubmitted ? 'Request Submitted' : 'Submit Request',
                    _requestSubmitted ? Icons.check_circle : Icons.send,
                    _requestSubmitted ? () {} : _handleSubmitRequest,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Removed unused _buildQuickActions

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF2F80ED)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  void _handleUploadDocuments() async {
    final List<String> types = <String>[
      'MRI',
      'Doctor Report',
      'CT Scan',
      'Blood Group',
      'Other Report',
    ];

    final List<_PatientDocument> temp = List<_PatientDocument>.from(_documents);

    Future<void> addDoc() async {
      String selectedType = types.first;
      String note = '';
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Document'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: types
                      .map(
                        (t) =>
                            DropdownMenuItem<String>(value: t, child: Text(t)),
                      )
                      .toList(),
                  onChanged: (v) => selectedType = v ?? selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  onChanged: (v) => note = v,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  temp.add(_PatientDocument(type: selectedType, note: note));
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }

    // Limit to 2 documents max
    while (temp.length < 2) {
      await addDoc();
      if (temp.length >= 2) break;
      bool addMore = false;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add another?'),
          content: const Text('You can upload up to 2 documents.'),
          actions: [
            TextButton(
              onPressed: () {
                addMore = false;
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                addMore = true;
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      if (!addMore) break;
    }

    setState(() {
      _documents
        ..clear()
        ..addAll(temp.take(2));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${_documents.length} document(s).')),
    );
  }

  void _handleSubmitRequest() async {
    setState(() => _requestSubmitted = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request submitted to admin.')),
    );
  }
}

class _PatientDocument {
  final String type;
  final String note;
  _PatientDocument({required this.type, required this.note});
}
