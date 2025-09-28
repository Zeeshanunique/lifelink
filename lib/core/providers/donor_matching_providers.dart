import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/donor_request.dart';
import '../services/donor_matching_service.dart';

// Donor Matching Service Provider
final donorMatchingServiceProvider = Provider<DonorMatchingService>((ref) {
  return MockDonorMatchingService();
});

// Active Matches Provider
final activeMatchesProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.watch(donorMatchingServiceProvider);
  return service.getActiveMatches();
});

// Pending Requests Provider
final pendingRequestsProvider = FutureProvider<List<DonorRequest>>((ref) async {
  final service = ref.watch(donorMatchingServiceProvider);
  return service.getPendingRequests();
});

// Completed Matches Provider
final completedMatchesProvider = FutureProvider<List<dynamic>>((ref) async {
  final service = ref.watch(donorMatchingServiceProvider);
  return service.getCompletedMatches();
});

// Compatible Donors Provider
final compatibleDonorsProvider = FutureProvider.family<List<dynamic>, String>((ref, requestId) async {
  final service = ref.watch(donorMatchingServiceProvider);
  return service.getCompatibleDonors(requestId);
});