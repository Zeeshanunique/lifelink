import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  String _selectedReportType = 'Hospital Performance';
  String _selectedTimeRange = 'Last 30 Days';
  bool _isGenerating = false;

  final List<String> _reportTypes = [
    'Hospital Performance',
    'Donor Statistics',
    'Transplant Success Rates',
    'Patient Demographics',
    'Financial Summary',
    'Compliance Report',
  ];

  final List<String> _timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'Last Year',
    'Custom Range',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Reports & Export'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _isGenerating ? null : _generateReport,
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Configuration Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generate Report',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedReportType,
                      decoration: const InputDecoration(
                        labelText: 'Report Type',
                        border: OutlineInputBorder(),
                      ),
                      items: _reportTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedReportType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedTimeRange,
                      decoration: const InputDecoration(
                        labelText: 'Time Range',
                        border: OutlineInputBorder(),
                      ),
                      items: _timeRanges.map((range) {
                        return DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeRange = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isGenerating ? null : _generateReport,
                        icon: _isGenerating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.assessment, size: 20),
                        label: Text(
                          _isGenerating ? 'Generating...' : 'Generate Report',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Available Reports Section
            const Text(
              'Available Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),

            // Report Cards
            _buildReportCard(
              'Hospital Performance Report',
              'Comprehensive analysis of hospital operations, patient outcomes, and resource utilization.',
              Icons.local_hospital,
              [
                'Patient Volume',
                'Success Rates',
                'Resource Usage',
                'Quality Metrics',
              ],
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              'Donor Statistics Report',
              'Detailed statistics on organ donor registrations, donations, and matching success rates.',
              Icons.favorite,
              [
                'Registration Trends',
                'Donation Rates',
                'Matching Success',
                'Geographic Analysis',
              ],
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              'Transplant Success Report',
              'Analysis of transplant procedures, success rates, and patient outcomes.',
              Icons.medical_services,
              [
                'Success Rates',
                'Complication Rates',
                'Recovery Times',
                'Long-term Outcomes',
              ],
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              'Financial Summary Report',
              'Financial performance metrics, revenue analysis, and cost breakdowns.',
              Icons.account_balance,
              [
                'Revenue Analysis',
                'Cost Breakdown',
                'Profit Margins',
                'Budget Performance',
              ],
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              'Compliance Report',
              'Regulatory compliance status, audit results, and certification tracking.',
              Icons.verified_user,
              [
                'Regulatory Status',
                'Audit Results',
                'Certifications',
                'Compliance Score',
              ],
            ),

            const SizedBox(height: 24),

            // Export Options
            const Text(
              'Export Options',
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
                  child: _buildExportOption(
                    'PDF',
                    Icons.picture_as_pdf,
                    () => _exportReport('PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildExportOption(
                    'Excel',
                    Icons.table_chart,
                    () => _exportReport('Excel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildExportOption(
                    'CSV',
                    Icons.table_view,
                    () => _exportReport('CSV'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String description,
    IconData icon,
    List<String> metrics,
  ) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F80ED).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF2F80ED), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _generateSpecificReport(title),
                  icon: const Icon(Icons.play_arrow),
                  color: const Color(0xFF2F80ED),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: metrics.map((metric) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    metric,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(String format, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2F80ED)),
            const SizedBox(height: 8),
            Text(
              format,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport() {
    setState(() {
      _isGenerating = true;
    });

    // Simulate report generation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$_selectedReportType report generated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _generateSpecificReport(String reportType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$reportType report generation started!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting report as $format...'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
