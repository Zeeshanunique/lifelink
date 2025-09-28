import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../services/auth_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

// Current User Provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AuthUser?>((ref) {
  return CurrentUserNotifier();
});

// Authentication State Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

// User Role Provider
final userRoleProvider = Provider<UserRole?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role;
});

class CurrentUserNotifier extends StateNotifier<AuthUser?> {
  CurrentUserNotifier() : super(null);

  void setUser(AuthUser user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateUser(AuthUser user) {
    state = user;
  }
}