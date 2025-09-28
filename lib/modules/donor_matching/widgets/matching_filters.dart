import 'package:flutter/material.dart';
import '../../../core/models/donor_request.dart';

class MatchingFilters extends StatefulWidget {
  final String selectedBloodType;
  final String selectedOrganType;
  final RequestUrgency selectedUrgency;
  final double maxDistanceKm;
  final Function(String, String, RequestUrgency, double) onApply;

  const MatchingFilters({
    super.key,
    required this.selectedBloodType,
    required this.selectedOrganType,
    required this.selectedUrgency,
    required this.maxDistanceKm,
    required this.onApply,
  });

  @override
  State<MatchingFilters> createState() => _MatchingFiltersState();
}

class _MatchingFiltersState extends State<MatchingFilters> {
  late String _bloodType;
  late String _organType;
  late RequestUrgency _urgency;
  late double _distance;

  final List<String> _bloodTypes = [
    'All',
    'O+',
    'O-',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-'
  ];

  final List<String> _organTypes = [
    'All',
    'Heart',
    'Kidney',
    'Liver',
    'Lung',
    'Pancreas',
    'Cornea'
  ];

  @override
  void initState() {
    super.initState();
    _bloodType = widget.selectedBloodType;
    _organType = widget.selectedOrganType;
    _urgency = widget.selectedUrgency;
    _distance = widget.maxDistanceKm;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Matches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Blood Type Filter
          const Text(
            'Blood Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bloodTypes.map((type) {
              final isSelected = _bloodType == type;
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _bloodType = type;
                  });
                },
                selectedColor: const Color(0xFF2F80ED).withOpacity(0.2),
                checkmarkColor: const Color(0xFF2F80ED),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Organ Type Filter
          const Text(
            'Organ Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _organTypes.map((type) {
              final isSelected = _organType == type;
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _organType = type;
                  });
                },
                selectedColor: const Color(0xFF10B981).withOpacity(0.2),
                checkmarkColor: const Color(0xFF10B981),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Urgency Filter
          const Text(
            'Request Urgency',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RequestUrgency.values.map((urgency) {
              final isSelected = _urgency == urgency;
              return FilterChip(
                label: Text(_getUrgencyLabel(urgency)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _urgency = urgency;
                  });
                },
                selectedColor: _getUrgencyColor(urgency).withOpacity(0.2),
                checkmarkColor: _getUrgencyColor(urgency),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Distance Filter
          const Text(
            'Maximum Distance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _distance,
                  min: 10.0,
                  max: 500.0,
                  divisions: 49,
                  label: '${_distance.round()} km',
                  onChanged: (value) {
                    setState(() {
                      _distance = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  '${_distance.round()} km',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _bloodType = 'All';
                      _organType = 'All';
                      _urgency = RequestUrgency.medium;
                      _distance = 100.0;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_bloodType, _organType, _urgency, _distance);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getUrgencyLabel(RequestUrgency urgency) {
    switch (urgency) {
      case RequestUrgency.low:
        return 'Low';
      case RequestUrgency.medium:
        return 'Medium';
      case RequestUrgency.high:
        return 'High';
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
}