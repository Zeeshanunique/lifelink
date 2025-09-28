import '../models/auth_user.dart';

/// Role-Based Access Control utility class
class RBACUtils {
  /// Check if user has permission for a specific feature
  static bool hasPermission(AuthUser? user, Permission permission) {
    if (user == null || !user.isActive) return false;

    switch (permission) {
      // Patient permissions
      case Permission.viewOwnMedicalRecords:
      case Permission.uploadMedicalDocuments:
      case Permission.createDonorRequest:
      case Permission.viewDonorMatching:
      case Permission.viewOwnAppointments:
      case Permission.viewDonorList:
        return user.isPatient || user.isHospital || user.isAdmin;

      // Hospital permissions
      case Permission.managePatients:
      case Permission.manageAppointments:
      case Permission.viewMedicalRecords:
      case Permission.verifyDocuments:
      case Permission.manageDonorRequests:
      case Permission.viewHospitalAnalytics:
        return user.isHospital || user.isAdmin;

      // Admin permissions
      case Permission.manageHospitals:
      case Permission.manageDonors:
      case Permission.viewSystemAnalytics:
      case Permission.manageUsers:
      case Permission.viewReports:
      case Permission.systemConfiguration:
        return user.isAdmin;

      // Mixed permissions
      case Permission.viewProfile:
      case Permission.editProfile:
      case Permission.viewNotifications:
        return true; // All authenticated users
    }
  }

  /// Check if user can access a specific route
  static bool canAccessRoute(AuthUser? user, String route) {
    if (user == null || !user.isActive) {
      return _isPublicRoute(route);
    }

    // Routes accessible by all authenticated users
    if (_isCommonRoute(route)) return true;

    switch (user.role) {
      case UserRole.patient:
        return _isPatientRoute(route);
      case UserRole.hospital:
        return _isHospitalRoute(route);
      case UserRole.admin:
        return _isAdminRoute(route);
    }
  }

  /// Check if user can perform action on resource
  static bool canPerformAction(
    AuthUser? user,
    ResourceAction action, {
    String? resourceOwnerId,
    String? hospitalId,
  }) {
    if (user == null || !user.isActive) return false;

    switch (action) {
      case ResourceAction.create:
        return hasPermission(user, _getCreatePermission(action));
      case ResourceAction.read:
        return _canRead(user, resourceOwnerId, hospitalId);
      case ResourceAction.update:
        return _canUpdate(user, resourceOwnerId, hospitalId);
      case ResourceAction.delete:
        return _canDelete(user, resourceOwnerId, hospitalId);
    }
  }

  /// Get user's accessible features
  static List<String> getAccessibleFeatures(AuthUser? user) {
    if (user == null || !user.isActive) return [];

    switch (user.role) {
      case UserRole.patient:
        return [
          'medical_records',
          'donor_requests',
          'donor_matching',
          'appointments',
          'profile',
          'notifications',
        ];
      case UserRole.hospital:
        return [
          'patient_management',
          'appointment_management',
          'medical_records',
          'donor_requests',
          'donor_matching',
          'hospital_analytics',
          'profile',
          'notifications',
        ];
      case UserRole.admin:
        return [
          'hospital_management',
          'donor_management',
          'patient_management',
          'appointment_management',
          'analytics',
          'reports',
          'user_management',
          'system_settings',
          'profile',
          'notifications',
        ];
    }
  }

  // Private helper methods
  static bool _isPublicRoute(String route) {
    return ['/login', '/register', '/onboarding', '/'].contains(route);
  }

  static bool _isCommonRoute(String route) {
    return ['/main', '/profile', '/settings', '/notifications'].contains(route);
  }

  static bool _isPatientRoute(String route) {
    return [
      '/medical-records',
      '/donor-requests',
      '/donor-matching',
    ].any((pattern) => route.startsWith(pattern));
  }

  static bool _isHospitalRoute(String route) {
    return [
      '/patients',
      '/appointments',
      '/medical-records',
      '/donor-requests',
      '/donor-matching',
      '/hospitals',
    ].any((pattern) => route.startsWith(pattern));
  }

  static bool _isAdminRoute(String route) {
    return [
      '/hospitals',
      '/donors',
      '/analytics',
      '/reports',
      '/admin',
    ].any((pattern) => route.startsWith(pattern));
  }

  static Permission _getCreatePermission(ResourceAction action) {
    // This would be expanded based on specific create actions
    return Permission.createDonorRequest;
  }

  static bool _canRead(
    AuthUser user,
    String? resourceOwnerId,
    String? hospitalId,
  ) {
    if (user.isAdmin) return true;

    if (user.isHospital) {
      // Hospital users can read resources in their hospital
      return hospitalId == null || hospitalId == user.hospitalId;
    }

    if (user.isPatient) {
      // Patients can only read their own resources
      return resourceOwnerId == null || resourceOwnerId == user.patientId;
    }

    return false;
  }

  static bool _canUpdate(
    AuthUser user,
    String? resourceOwnerId,
    String? hospitalId,
  ) {
    if (user.isAdmin) return true;

    if (user.isHospital) {
      // Hospital users can update resources in their hospital
      return hospitalId == null || hospitalId == user.hospitalId;
    }

    if (user.isPatient) {
      // Patients can only update their own resources
      return resourceOwnerId == null || resourceOwnerId == user.patientId;
    }

    return false;
  }

  static bool _canDelete(
    AuthUser user,
    String? resourceOwnerId,
    String? hospitalId,
  ) {
    if (user.isAdmin) return true;

    if (user.isHospital) {
      // Hospital users can delete resources in their hospital (limited)
      return hospitalId == null || hospitalId == user.hospitalId;
    }

    // Patients typically cannot delete critical medical records
    return false;
  }
}

/// Available permissions in the system
enum Permission {
  // Patient permissions
  viewOwnMedicalRecords,
  uploadMedicalDocuments,
  createDonorRequest,
  viewDonorMatching,
  viewOwnAppointments,
  viewDonorList,

  // Hospital permissions
  managePatients,
  manageAppointments,
  viewMedicalRecords,
  verifyDocuments,
  manageDonorRequests,
  viewHospitalAnalytics,

  // Admin permissions
  manageHospitals,
  manageDonors,
  viewSystemAnalytics,
  manageUsers,
  viewReports,
  systemConfiguration,

  // Common permissions
  viewProfile,
  editProfile,
  viewNotifications,
}

/// Resource actions
enum ResourceAction { create, read, update, delete }
