import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/donor_request.dart';
import 'request_success_page.dart';
import '../../../core/providers/hospital_providers.dart';

class CreateDonorRequestPage extends ConsumerStatefulWidget {
  const CreateDonorRequestPage({super.key});

  @override
  ConsumerState<CreateDonorRequestPage> createState() =>
      _CreateDonorRequestPageState();
}

class _CreateDonorRequestPageState
    extends ConsumerState<CreateDonorRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _medicalReasonController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedHospitalId;
  String? _selectedDoctorId;
  String _selectedBloodType = 'O+';
  RequestUrgency _selectedUrgency = RequestUrgency.medium;
  List<String> _selectedOrgans = [];
  DateTime _neededByDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  final List<String> _bloodTypes = [
    'O+',
    'O-',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
  ];
  final List<String> _availableOrgans = [
    'Heart',
    'Kidney',
    'Liver',
    'Lung',
    'Pancreas',
    'Cornea',
  ];
  final List<String> _mockDoctors = [
    'Dr. Sarah Johnson',
    'Dr. Michael Chen',
    'Dr. Emily Rodriguez',
    'Dr. David Wilson',
    'Dr. Lisa Anderson',
  ];

  @override
  void dispose() {
    _patientIdController.dispose();
    _medicalReasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Create Donor Request'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF10B981),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Organ Request',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Submit a request to find compatible organ donors',
                            style: TextStyle(
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

              const SizedBox(height: 24),

              // Patient Information Section
              _buildSectionCard('Patient Information', Icons.person, [
                TextFormField(
                  controller: _patientIdController,
                  decoration: const InputDecoration(
                    labelText: 'Patient ID',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter patient ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBloodType,
                  decoration: const InputDecoration(
                    labelText: 'Blood Type',
                    prefixIcon: Icon(Icons.bloodtype),
                    border: OutlineInputBorder(),
                  ),
                  items: _bloodTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodType = value!;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 16),

              // Hospital & Doctor Selection
              _buildSectionCard('Hospital & Doctor', Icons.local_hospital, [
                Consumer(
                  builder: (context, ref, child) {
                    final hospitalsAsync = ref.watch(hospitalsProvider);
                    return hospitalsAsync.when(
                      data: (hospitals) => DropdownButtonFormField<String>(
                        value: _selectedHospitalId,
                        decoration: const InputDecoration(
                          labelText: 'Hospital',
                          prefixIcon: Icon(Icons.local_hospital_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items: hospitals.map((hospital) {
                          return DropdownMenuItem(
                            value: hospital.id,
                            child: Text(hospital.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedHospitalId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a hospital';
                          }
                          return null;
                        },
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const Text('Failed to load hospitals'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDoctorId,
                  decoration: const InputDecoration(
                    labelText: 'Requesting Doctor',
                    prefixIcon: Icon(Icons.person_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _mockDoctors.map((doctor) {
                    return DropdownMenuItem(value: doctor, child: Text(doctor));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDoctorId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a doctor';
                    }
                    return null;
                  },
                ),
              ]),

              const SizedBox(height: 16),

              // Organ Requirements
              _buildSectionCard('Organ Requirements', Icons.favorite, [
                const Text(
                  'Select Required Organs:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableOrgans.map((organ) {
                    final isSelected = _selectedOrgans.contains(organ);
                    return FilterChip(
                      label: Text(organ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedOrgans.add(organ);
                          } else {
                            _selectedOrgans.remove(organ);
                          }
                        });
                      },
                      selectedColor: const Color(0xFF10B981).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF10B981),
                    );
                  }).toList(),
                ),
                if (_selectedOrgans.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Please select at least one organ',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ]),

              const SizedBox(height: 16),

              // Medical Details
              _buildSectionCard('Medical Details', Icons.medical_services, [
                DropdownButtonFormField<RequestUrgency>(
                  value: _selectedUrgency,
                  decoration: const InputDecoration(
                    labelText: 'Urgency Level',
                    prefixIcon: Icon(Icons.priority_high),
                    border: OutlineInputBorder(),
                  ),
                  items: RequestUrgency.values.map((urgency) {
                    return DropdownMenuItem(
                      value: urgency,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getUrgencyColor(urgency),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(_getUrgencyLabel(urgency)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUrgency = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _medicalReasonController,
                  decoration: const InputDecoration(
                    labelText: 'Medical Reason',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                    hintText: 'e.g., End-stage heart failure',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the medical reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _neededByDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 2),
                      ),
                    );
                    if (date != null) {
                      setState(() {
                        _neededByDate = date;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Needed By',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      '${_neededByDate.day}/${_neededByDate.month}/${_neededByDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes (Optional)',
                    prefixIcon: Icon(Icons.notes_outlined),
                    border: OutlineInputBorder(),
                    hintText: 'Any additional information...',
                  ),
                  maxLines: 3,
                ),
              ]),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Donor Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  String _getUrgencyLabel(RequestUrgency urgency) {
    switch (urgency) {
      case RequestUrgency.low:
        return 'Low Priority';
      case RequestUrgency.medium:
        return 'Medium Priority';
      case RequestUrgency.high:
        return 'High Priority';
      case RequestUrgency.critical:
        return 'Critical';
    }
  }

  Color _getUrgencyColor(RequestUrgency urgency) {
    switch (urgency) {
      case RequestUrgency.low:
        return Colors.green;
      case RequestUrgency.medium:
        return Colors.orange;
      case RequestUrgency.high:
        return Colors.red;
      case RequestUrgency.critical:
        return Colors.red.shade700;
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedOrgans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one organ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      // Generate request ID and navigate to success page
      final requestId =
          'REQ-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      // Create donor request object for the success page
      final donorRequest = DonorRequest(
        id: requestId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        patientId:
            'current-patient-id', // TODO: Get from actual patient context
        hospitalId: _selectedHospitalId ?? 'default-hospital',
        requestingDoctorId: _selectedDoctorId ?? 'current-doctor-id',
        organsNeeded: _selectedOrgans.toList(),
        bloodType: _selectedBloodType,
        urgency: _selectedUrgency,
        medicalReason: _medicalReasonController.text,
        medicalRequirements: {
          'urgency': _selectedUrgency.name,
          'additional_info': _notesController.text,
        },
        neededBy: _neededByDate,
        notes: _notesController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RequestSuccessPage(
            donorRequest: donorRequest,
            requestId: requestId,
            submittedDate: DateTime.now(),
          ),
        ),
      );
    }
  }
}
