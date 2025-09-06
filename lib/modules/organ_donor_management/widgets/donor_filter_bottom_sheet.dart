import 'package:flutter/material.dart';

class DonorFilterBottomSheet extends StatefulWidget {
  final String selectedStatus;
  final String selectedBloodType;
  final String selectedOrganType;
  final bool showActiveOnly;
  final Function(
    String status,
    String bloodType,
    String organType,
    bool activeOnly,
  )
  onApplyFilters;

  const DonorFilterBottomSheet({
    super.key,
    required this.selectedStatus,
    required this.selectedBloodType,
    required this.selectedOrganType,
    required this.showActiveOnly,
    required this.onApplyFilters,
  });

  @override
  State<DonorFilterBottomSheet> createState() => _DonorFilterBottomSheetState();
}

class _DonorFilterBottomSheetState extends State<DonorFilterBottomSheet> {
  late String _selectedStatus;
  late String _selectedBloodType;
  late String _selectedOrganType;
  late bool _showActiveOnly;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.selectedStatus;
    _selectedBloodType = widget.selectedBloodType;
    _selectedOrganType = widget.selectedOrganType;
    _showActiveOnly = widget.showActiveOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Filter Donors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = 'All';
                      _selectedBloodType = 'All';
                      _selectedOrganType = 'All';
                      _showActiveOnly = false;
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Filter
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          'All',
                          'Registered',
                          'Active',
                          'Inactive',
                          'Deceased',
                          'Transplanted',
                        ].map((status) {
                          return FilterChip(
                            label: Text(status),
                            selected: _selectedStatus == status,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatus = selected ? status : 'All';
                              });
                            },
                            selectedColor: const Color(
                              0xFF2D7CFF,
                            ).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF2D7CFF),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Blood Type Filter
                  const Text(
                    'Blood Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          'All',
                          'A+',
                          'A-',
                          'B+',
                          'B-',
                          'AB+',
                          'AB-',
                          'O+',
                          'O-',
                        ].map((bloodType) {
                          return FilterChip(
                            label: Text(bloodType),
                            selected: _selectedBloodType == bloodType,
                            onSelected: (selected) {
                              setState(() {
                                _selectedBloodType = selected
                                    ? bloodType
                                    : 'All';
                              });
                            },
                            selectedColor: const Color(
                              0xFF2D7CFF,
                            ).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF2D7CFF),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Organ Type Filter
                  const Text(
                    'Organ Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          'All',
                          'Heart',
                          'Lung',
                          'Liver',
                          'Kidney',
                          'Pancreas',
                          'Intestine',
                          'Cornea',
                          'Skin',
                          'Bone',
                          'Tissue',
                        ].map((organType) {
                          return FilterChip(
                            label: Text(organType),
                            selected: _selectedOrganType == organType,
                            onSelected: (selected) {
                              setState(() {
                                _selectedOrganType = selected
                                    ? organType
                                    : 'All';
                              });
                            },
                            selectedColor: const Color(
                              0xFF2D7CFF,
                            ).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF2D7CFF),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Special Filters
                  const Text(
                    'Special Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Active Donors Only'),
                    subtitle: const Text('Show only currently active donors'),
                    value: _showActiveOnly,
                    onChanged: (value) {
                      setState(() {
                        _showActiveOnly = value;
                      });
                    },
                    activeColor: const Color(0xFF2D7CFF),
                  ),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(
                        _selectedStatus,
                        _selectedBloodType,
                        _selectedOrganType,
                        _showActiveOnly,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7CFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
