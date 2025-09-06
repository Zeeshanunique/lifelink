import 'package:flutter/material.dart';

class HospitalFilterBottomSheet extends StatefulWidget {
  final String selectedType;
  final String selectedCity;
  final bool showOrganTransplantOnly;
  final Function(String type, String city, bool organTransplant) onApplyFilters;

  const HospitalFilterBottomSheet({
    super.key,
    required this.selectedType,
    required this.selectedCity,
    required this.showOrganTransplantOnly,
    required this.onApplyFilters,
  });

  @override
  State<HospitalFilterBottomSheet> createState() =>
      _HospitalFilterBottomSheetState();
}

class _HospitalFilterBottomSheetState extends State<HospitalFilterBottomSheet> {
  late String _selectedType;
  late String _selectedCity;
  late bool _showOrganTransplantOnly;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _selectedCity = widget.selectedCity;
    _showOrganTransplantOnly = widget.showOrganTransplantOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                  'Filter Hospitals',
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
                      _selectedType = 'All';
                      _selectedCity = 'All';
                      _showOrganTransplantOnly = false;
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
                  // Hospital Type Filter
                  const Text(
                    'Hospital Type',
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
                          'General Hospital',
                          'Specialty Hospital',
                          'Teaching Hospital',
                          'Research Hospital',
                          'Emergency Hospital',
                          'Rehabilitation Center',
                        ].map((type) {
                          return FilterChip(
                            label: Text(type),
                            selected: _selectedType == type,
                            onSelected: (selected) {
                              setState(() {
                                _selectedType = selected ? type : 'All';
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

                  // City Filter
                  const Text(
                    'City',
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
                          'New York',
                          'Los Angeles',
                          'Chicago',
                          'Houston',
                          'Phoenix',
                          'Philadelphia',
                          'San Antonio',
                          'San Diego',
                          'Dallas',
                          'San Jose',
                        ].map((city) {
                          return FilterChip(
                            label: Text(city),
                            selected: _selectedCity == city,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCity = selected ? city : 'All';
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

                  // Special Features Filter
                  const Text(
                    'Special Features',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Organ Transplant Capability'),
                    subtitle: const Text(
                      'Show only hospitals with organ transplant facilities',
                    ),
                    value: _showOrganTransplantOnly,
                    onChanged: (value) {
                      setState(() {
                        _showOrganTransplantOnly = value;
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
                        _selectedType,
                        _selectedCity,
                        _showOrganTransplantOnly,
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
