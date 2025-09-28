import '../models/auth_user.dart';
import '../utils/result.dart';
import '../errors/failures.dart';

abstract class AuthService {
  Future<Result<AuthResponse>> login(LoginRequest request);
  Future<Result<AuthResponse>> register(RegisterRequest request);
  Future<Result<void>> logout();
  Future<Result<AuthUser?>> getCurrentUser();
  Future<Result<AuthResponse>> refreshToken();
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword(String token, String newPassword);
  Future<Result<AuthUser>> updateProfile(AuthUser user);
  Future<Result<void>> changePassword(String oldPassword, String newPassword);
  Future<Result<void>> verifyEmail(String token);
  Future<Result<void>> resendEmailVerification();
}

class MockAuthService implements AuthService {
  AuthResponse? _currentAuthResponse;

  final List<AuthUser> _mockUsers = [
    AuthUser(
      id: 'admin_1',
      email: 'admin@lifelink.com',
      firstName: 'Admin',
      lastName: 'User',
      role: UserRole.admin,
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    AuthUser(
      id: 'hospital_1',
      email: 'hospital@citygeneral.com',
      firstName: 'City General',
      lastName: 'Hospital',
      role: UserRole.hospital,
      hospitalId: '1',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    AuthUser(
      id: 'patient_1',
      email: 'john.doe@email.com',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1-555-0123',
      role: UserRole.patient,
      patientId: 'patient_123',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<Result<AuthResponse>> login(LoginRequest request) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Simple mock validation
      final user = _mockUsers.firstWhere(
        (u) => u.email == request.email && u.role == request.role,
        orElse: () => throw Exception('Invalid credentials'),
      );

      if (!user.isActive) {
        return Result.failure(AuthenticationFailure('Account is deactivated'));
      }

      final authResponse = AuthResponse(
        user: user.copyWith(lastLoginAt: DateTime.now()),
        token: 'mock_token_${user.id}',
        refreshToken: 'mock_refresh_token_${user.id}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      _currentAuthResponse = authResponse;
      return Result.success(authResponse);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Login failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<AuthResponse>> register(RegisterRequest request) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check if user already exists
      final existingUser = _mockUsers.where((u) => u.email == request.email);
      if (existingUser.isNotEmpty) {
        return Result.failure(AuthenticationFailure('User already exists'));
      }

      final newUser = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: request.email,
        firstName: request.firstName,
        lastName: request.lastName,
        phoneNumber: request.phoneNumber,
        role: request.role,
        hospitalId: request.hospitalId,
        isActive: true,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _mockUsers.add(newUser);

      final authResponse = AuthResponse(
        user: newUser,
        token: 'mock_token_${newUser.id}',
        refreshToken: 'mock_refresh_token_${newUser.id}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      _currentAuthResponse = authResponse;
      return Result.success(authResponse);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Registration failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _currentAuthResponse = null;
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Logout failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<AuthUser?>> getCurrentUser() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return Result.success(_currentAuthResponse?.user);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Failed to get current user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<AuthResponse>> refreshToken() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (_currentAuthResponse == null) {
        return Result.failure(AuthenticationFailure('No active session'));
      }

      final newAuthResponse = AuthResponse(
        user: _currentAuthResponse!.user,
        token: 'refreshed_token_${_currentAuthResponse!.user.id}',
        refreshToken:
            'refreshed_refresh_token_${_currentAuthResponse!.user.id}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );

      _currentAuthResponse = newAuthResponse;
      return Result.success(newAuthResponse);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Token refresh failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // Mock implementation - always succeeds
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Password reset failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> resetPassword(String token, String newPassword) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // Mock implementation - always succeeds
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Password reset failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<AuthUser>> updateProfile(AuthUser user) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _mockUsers.indexWhere((u) => u.id == user.id);
      if (index == -1) {
        return Result.failure(AuthenticationFailure('User not found'));
      }

      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      _mockUsers[index] = updatedUser;

      if (_currentAuthResponse?.user.id == user.id) {
        _currentAuthResponse = _currentAuthResponse!.copyWith(
          user: updatedUser,
        );
      }

      return Result.success(updatedUser);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Profile update failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // Mock implementation - always succeeds
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Password change failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Mock implementation - always succeeds
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Email verification failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> resendEmailVerification() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // Mock implementation - always succeeds
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        AuthenticationFailure('Resend verification failed: ${e.toString()}'),
      );
    }
  }
}

extension AuthResponseCopyWith on AuthResponse {
  AuthResponse copyWith({
    AuthUser? user,
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthResponse(
      user: user ?? this.user,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
