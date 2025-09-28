import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/donor_request.dart';
import '../../../core/providers/donor_matching_providers.dart';
import '../widgets/match_card.dart';
import '../widgets/matching_filters.dart';

class DonorMatchingPage extends ConsumerStatefulWidget {
  const DonorMatchingPage({super.key});

  @override
  ConsumerState<DonorMatchingPage> createState() => _DonorMatchingPageState();
}

class _DonorMatchingPageState extends ConsumerState<DonorMatchingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedBloodType = 'All';
  String _selectedOrganType = 'All';
  RequestUrgency _selectedUrgency = RequestUrgency.medium;
  double _maxDistanceKm = 100.0;

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Donor Matching'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filters',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create-donor-request');
            },
            icon: const Icon(Icons.add),
            tooltip: 'New Request',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2F80ED),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF2F80ED),
          tabs: const [
            Tab(text: 'Active Matches'),
            Tab(text: 'Pending Requests'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveMatchesTab(),
          _buildPendingRequestsTab(),
          _buildCompletedTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateRequestDialog();
        },
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  Widget _buildActiveMatchesTab() {
    final matchesAsync = ref.watch(activeMatchesProvider);

    return matchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          return _buildEmptyState(
            icon: Icons.search_off,
            title: 'No Active Matches',
            subtitle:
                'There are currently no active donor matches.\nCreate a new request to find compatible donors.',
            actionLabel: 'Create Request',
            onAction: _showCreateRequestDialog,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeMatchesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MatchCard(
                  match: match,
                  onTap: () => _showMatchDetails(match),
                  onAccept: () => _acceptMatch(match),
                  onReject: () => _rejectMatch(match),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildPendingRequestsTab() {
    final requestsAsync = ref.watch(pendingRequestsProvider);

    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return _buildEmptyState(
            icon: Icons.pending_actions,
            title: 'No Pending Requests',
            subtitle: 'All requests have been processed or matched.',
            actionLabel: 'Create Request',
            onAction: _showCreateRequestDialog,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildRequestCard(request),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildCompletedTab() {
    final completedAsync = ref.watch(completedMatchesProvider);

    return completedAsync.when(
      data: (completed) {
        if (completed.isEmpty) {
          return _buildEmptyState(
            icon: Icons.check_circle_outline,
            title: 'No Completed Matches',
            subtitle: 'Completed matches and transplants will appear here.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: completed.length,
          itemBuilder: (context, index) {
            final match = completed[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCompletedCard(match),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildRequestCard(DonorRequest request) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getUrgencyColor(request.urgency).withOpacity(0.3),
          width: 2,
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getUrgencyColor(request.urgency).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  request.urgencyString.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getUrgencyColor(request.urgency),
                  ),
                ),
              ),
              Text(
                '${request.daysUntilNeeded} days left',
                style: TextStyle(
                  fontSize: 12,
                  color: request.isOverdue ? Colors.red : Colors.grey[600],
                  fontWeight: request.isOverdue
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Organs needed: ${request.organsNeeded.join(', ')}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Blood Type: ${request.bloodType}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Reason: ${request.medicalReason}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _editRequest(request),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _findMatches(request),
                  child: const Text('Find Matches'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(dynamic match) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Match Completed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Transplant successful on ${DateTime.now().subtract(const Duration(days: 5)).day}/${DateTime.now().subtract(const Duration(days: 5)).month}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Organ: Heart',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                'Blood Type: O+',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Show completion details
              },
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFF9CA3AF)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(activeMatchesProvider);
              ref.invalidate(pendingRequestsProvider);
              ref.invalidate(completedMatchesProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MatchingFilters(
        selectedBloodType: _selectedBloodType,
        selectedOrganType: _selectedOrganType,
        selectedUrgency: _selectedUrgency,
        maxDistanceKm: _maxDistanceKm,
        onApply: (bloodType, organType, urgency, distance) {
          setState(() {
            _selectedBloodType = bloodType;
            _selectedOrganType = organType;
            _selectedUrgency = urgency;
            _maxDistanceKm = distance;
          });
          // Apply filters to providers
        },
      ),
    );
  }

  void _showCreateRequestDialog() {
    Navigator.pushNamed(context, '/create-donor-request');
  }

  void _showMatchDetails(dynamic match) {
    Navigator.pushNamed(context, '/match-details', arguments: match);
  }

  void _acceptMatch(dynamic match) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Match'),
        content: const Text(
          'Are you sure you want to accept this donor match?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle accept match
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Match accepted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _rejectMatch(dynamic match) {
    Navigator.pop(context);
    // Handle reject match
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Match rejected'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _editRequest(DonorRequest request) {
    Navigator.pushNamed(context, '/edit-donor-request', arguments: request);
  }

  void _findMatches(DonorRequest request) {
    // Trigger matching algorithm
    ref.read(donorMatchingServiceProvider).findMatches(request.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Finding compatible donors...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
