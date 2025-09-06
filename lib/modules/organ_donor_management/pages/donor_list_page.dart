import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/organ_donor.dart';
import '../../../core/providers/organ_donor_providers.dart';
import '../widgets/donor_card.dart';
import '../widgets/donor_filter_bottom_sheet.dart';
import 'donor_details_page.dart';
import 'add_donor_page.dart';

class DonorListPage extends ConsumerStatefulWidget {
  const DonorListPage({super.key});

  @override
  ConsumerState<DonorListPage> createState() => _DonorListPageState();
}

class _DonorListPageState extends ConsumerState<DonorListPage> {
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedBloodType = 'All';
  String _selectedOrganType = 'All';
  bool _showActiveOnly = false;

  @override
  Widget build(BuildContext context) {
    final donorsAsync = ref.watch(organDonorsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Organ Donors'),
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
                MaterialPageRoute(builder: (context) => const AddDonorPage()),
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
                hintText: 'Search donors...',
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
                  _buildFilterChip('All', _selectedStatus == 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', _selectedStatus == 'Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Registered',
                    _selectedStatus == 'Registered',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip('Deceased', _selectedStatus == 'Deceased'),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Transplanted',
                    _selectedStatus == 'Transplanted',
                  ),
                ],
              ),
            ),
          ),

          // Donors List
          Expanded(
            child: donorsAsync.when(
              data: (donors) {
                final filteredDonors = _filterDonors(donors);

                if (filteredDonors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_outline,
                          size: 64,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No donors found',
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
                  itemCount: filteredDonors.length,
                  itemBuilder: (context, index) {
                    final donor = filteredDonors[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DonorCard(
                        donor: donor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DonorDetailsPage(donor: donor),
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
                      'Failed to load donors',
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
                        ref.invalidate(organDonorsProvider);
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
          _selectedStatus = selected ? label : 'All';
        });
      },
      selectedColor: const Color(0xFF2D7CFF).withOpacity(0.2),
      checkmarkColor: const Color(0xFF2D7CFF),
    );
  }

  List<OrganDonor> _filterDonors(List<OrganDonor> donors) {
    return donors.where((donor) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!donor.firstName.toLowerCase().contains(query) &&
            !donor.lastName.toLowerCase().contains(query) &&
            !donor.city.toLowerCase().contains(query) &&
            !donor.state.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Status filter
      if (_selectedStatus != 'All' && donor.status != _selectedStatus) {
        return false;
      }

      // Blood type filter
      if (_selectedBloodType != 'All' &&
          donor.bloodType != _selectedBloodType) {
        return false;
      }

      // Organ type filter
      if (_selectedOrganType != 'All' &&
          !donor.organsToDonate.contains(_selectedOrganType)) {
        return false;
      }

      // Active only filter
      if (_showActiveOnly && !donor.isActive) {
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
      builder: (context) => DonorFilterBottomSheet(
        selectedStatus: _selectedStatus,
        selectedBloodType: _selectedBloodType,
        selectedOrganType: _selectedOrganType,
        showActiveOnly: _showActiveOnly,
        onApplyFilters: (status, bloodType, organType, activeOnly) {
          setState(() {
            _selectedStatus = status;
            _selectedBloodType = bloodType;
            _selectedOrganType = organType;
            _showActiveOnly = activeOnly;
          });
        },
      ),
    );
  }
}
