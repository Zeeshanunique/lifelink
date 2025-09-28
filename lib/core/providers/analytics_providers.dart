import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics.dart';
import '../services/analytics_service.dart';

// Analytics Service Provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return MockAnalyticsService();
});

// Dashboard Stats Provider
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getDashboardStats();
});

// Hospital Analytics Provider
final hospitalAnalyticsProvider = FutureProvider.family<HospitalAnalytics, String>((ref, hospitalId) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getHospitalAnalytics(hospitalId);
});

// Donor Analytics Provider
final donorAnalyticsProvider = FutureProvider<DonorAnalytics>((ref) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getDonorAnalytics();
});

// Transplant Reports Provider
final transplantReportsProvider = FutureProvider.family<List<TransplantReport>, Map<String, dynamic>>((ref, filters) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getTransplantReports(filters);
});