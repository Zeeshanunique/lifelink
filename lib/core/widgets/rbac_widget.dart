import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../providers/auth_providers.dart';
import '../utils/rbac_utils.dart';

/// Widget that conditionally shows/hides content based on user permissions
class RBACWidget extends ConsumerWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;
  final String? resourceOwnerId;
  final String? hospitalId;

  const RBACWidget({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
    this.resourceOwnerId,
    this.hospitalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (RBACUtils.hasPermission(user, permission)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget that shows content only for specific roles
class RoleBasedWidget extends ConsumerWidget {
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user != null && allowedRoles.contains(user.role)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget that conditionally shows content based on route access
class RouteGuardWidget extends ConsumerWidget {
  final String route;
  final Widget child;
  final Widget? unauthorizedWidget;

  const RouteGuardWidget({
    super.key,
    required this.route,
    required this.child,
    this.unauthorizedWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (RBACUtils.canAccessRoute(user, route)) {
      return child;
    }

    return unauthorizedWidget ?? _buildUnauthorizedWidget(context);
  }

  Widget _buildUnauthorizedWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Access Denied',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'You do not have permission to access this page.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/main'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget that shows different content based on user role
class RoleBasedSwitcher extends ConsumerWidget {
  final Widget? patientWidget;
  final Widget? hospitalWidget;
  final Widget? adminWidget;
  final Widget? defaultWidget;

  const RoleBasedSwitcher({
    super.key,
    this.patientWidget,
    this.hospitalWidget,
    this.adminWidget,
    this.defaultWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return defaultWidget ?? const SizedBox.shrink();
    }

    switch (user.role) {
      case UserRole.patient:
        return patientWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.hospital:
        return hospitalWidget ?? defaultWidget ?? const SizedBox.shrink();
      case UserRole.admin:
        return adminWidget ?? defaultWidget ?? const SizedBox.shrink();
    }
  }
}

/// Builder widget for more complex role-based logic
class RoleBasedBuilder extends ConsumerWidget {
  final Widget Function(BuildContext context, AuthUser? user) builder;

  const RoleBasedBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return builder(context, user);
  }
}

/// Action-based access control widget
class ActionGuardWidget extends ConsumerWidget {
  final ResourceAction action;
  final Widget child;
  final Widget? fallback;
  final String? resourceOwnerId;
  final String? hospitalId;

  const ActionGuardWidget({
    super.key,
    required this.action,
    required this.child,
    this.fallback,
    this.resourceOwnerId,
    this.hospitalId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (RBACUtils.canPerformAction(
      user,
      action,
      resourceOwnerId: resourceOwnerId,
      hospitalId: hospitalId,
    )) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
