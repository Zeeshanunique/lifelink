import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/hospital.dart';
import '../../../core/providers/hospital_providers.dart';
import '../widgets/hospital_card.dart';
import '../widgets/hospital_filter_bottom_sheet.dart';
import 'hospital_details_page.dart';
import 'add_hospital_page.dart';

class HospitalListPage extends ConsumerStatefulWidget {
  const HospitalListPage({super.key});

  @override
  ConsumerState<HospitalListPage> createState() => _HospitalListPageState();
}

class _HospitalListPageState extends ConsumerState<HospitalListPage> {
  String _searchQuery = '';
  String _selectedType = 'All';
  String _selectedCity = 'All';
  bool _showOrganTransplantOnly = false;

  @override
  Widget build(BuildContext context) {
    final hospitalsAsync = ref.watch(hospitalsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Hospitals'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHospitalPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search hospitals...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2D7CFF)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Types', _selectedType == 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'General',
                    _selectedType == 'General Hospital',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Specialty',
                    _selectedType == 'Specialty Hospital',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Teaching',
                    _selectedType == 'Teaching Hospital',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Organ Transplant',
                    _showOrganTransplantOnly,
                  ),
                ],
              ),
            ),
          ),

          // Hospitals List
          Expanded(
            child: hospitalsAsync.when(
              data: (hospitals) {
                final filteredHospitals = _filterHospitals(hospitals);

                if (filteredHospitals.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          size: 64,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hospitals found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredHospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = filteredHospitals[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HospitalCard(
                        hospital: hospital,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HospitalDetailsPage(hospital: hospital),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
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
                      'Failed to load hospitals',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(hospitalsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (label == 'All Types') {
            _selectedType = selected ? 'All' : _selectedType;
          } else if (label == 'General') {
            _selectedType = selected ? 'General Hospital' : 'All';
          } else if (label == 'Specialty') {
            _selectedType = selected ? 'Specialty Hospital' : 'All';
          } else if (label == 'Teaching') {
            _selectedType = selected ? 'Teaching Hospital' : 'All';
          } else if (label == 'Organ Transplant') {
            _showOrganTransplantOnly = selected;
          }
        });
      },
      selectedColor: const Color(0xFF2D7CFF).withOpacity(0.2),
      checkmarkColor: const Color(0xFF2D7CFF),
    );
  }

  List<Hospital> _filterHospitals(List<Hospital> hospitals) {
    return hospitals.where((hospital) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!hospital.name.toLowerCase().contains(query) &&
            !hospital.city.toLowerCase().contains(query) &&
            !hospital.state.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Type filter
      if (_selectedType != 'All' && hospital.type != _selectedType) {
        return false;
      }

      // Organ transplant filter
      if (_showOrganTransplantOnly && !hospital.hasOrganTransplantCapability) {
        return false;
      }

      return true;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HospitalFilterBottomSheet(
        selectedType: _selectedType,
        selectedCity: _selectedCity,
        showOrganTransplantOnly: _showOrganTransplantOnly,
        onApplyFilters: (type, city, organTransplant) {
          setState(() {
            _selectedType = type;
            _selectedCity = city;
            _showOrganTransplantOnly = organTransplant;
          });
        },
      ),
    );
  }
}
