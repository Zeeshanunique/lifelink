import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'core/providers/auth_providers.dart';
import 'core/utils/rbac_utils.dart';
import 'core/widgets/rbac_widget.dart';
import 'modules/auth/pages/login_page.dart';
import 'modules/navigation/modular_navigation_page.dart';
import 'core/models/auth_user.dart';
import 'modules/hospital_management/pages/hospital_list_page.dart';
import 'modules/organ_donor_management/pages/donor_list_page.dart';
import 'modules/patient_management/pages/patient_list_page.dart';
import 'modules/appointment_management/pages/appointment_list_page.dart';
import 'modules/hospital_management/pages/add_hospital_page.dart';
import 'modules/organ_donor_management/pages/add_donor_page.dart';
import 'modules/patient_management/pages/add_patient_page.dart';
import 'modules/patient_management/pages/patient_page.dart';
import 'modules/patient_management/pages/medical_records_page.dart';
import 'modules/analytics/pages/analytics_dashboard.dart';
import 'modules/notifications/pages/notifications_page.dart';
import 'modules/donor_matching/pages/donor_matching_page.dart';
import 'modules/donor_requests/pages/create_donor_request_page.dart';
import 'modules/profile/pages/profile_page.dart';
import 'modules/settings/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LifeLink - Complete Medical Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F80ED)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1F2937)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final isAuthenticated = ref.watch(isAuthenticatedProvider);
          return isAuthenticated
              ? const ModularNavigationPage()
              : const LoginPage();
        },
      ),
      routes: {
        // Public routes
        '/login': (context) => const LoginPage(),

        // Common authenticated routes
        '/main': (context) => const ModularNavigationPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/notifications': (context) => const NotificationsPage(),

        // Hospital & Admin routes
        '/hospitals': (context) => const RouteGuardWidget(
          route: '/hospitals',
          child: HospitalListPage(),
        ),
        '/add-hospital': (context) => const RouteGuardWidget(
          route: '/add-hospital',
          child: AddHospitalPage(),
        ),

        // Hospital routes
        '/patients': (context) => const RouteGuardWidget(
          route: '/patients',
          child: PatientListPage(),
        ),
        '/appointments': (context) => const RouteGuardWidget(
          route: '/appointments',
          child: AppointmentListPage(),
        ),
        '/add-patient': (context) => const RouteGuardWidget(
          route: '/add-patient',
          child: AddPatientPage(),
        ),

        // Patient & Hospital routes
        '/medical-records': (context) => const RouteGuardWidget(
          route: '/medical-records',
          child: MedicalRecordsPage(),
        ),
        '/donor-matching': (context) => const RouteGuardWidget(
          route: '/donor-matching',
          child: DonorMatchingPage(),
        ),
        '/create-donor-request': (context) => const RouteGuardWidget(
          route: '/create-donor-request',
          child: CreateDonorRequestPage(),
        ),

        // Admin & Patient routes
        '/donors': (context) =>
            const RouteGuardWidget(route: '/donors', child: DonorListPage()),
        '/add-donor': (context) =>
            const RouteGuardWidget(route: '/add-donor', child: AddDonorPage()),

        // Admin routes
        '/analytics': (context) => const RouteGuardWidget(
          route: '/analytics',
          child: AnalyticsDashboard(),
        ),
      },
      onGenerateRoute: (settings) {
        final role = ref.read(userRoleProvider);
        bool allow = true;
        final name = settings.name;

        // Handle dynamic routes
        if (name?.startsWith('/patient/') == true) {
          final patientId = name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => PatientPage(patientId: patientId),
          );
        }

        if (role == null) {
          allow = name == '/login';
        } else {
          switch (role) {
            case UserRole.patient:
              if (name == '/hospitals' ||
                  name == '/appointments' ||
                  name == '/analytics') {
                allow = false;
              }
              break;
            case UserRole.hospital:
              if (name == '/analytics') {
                allow = false;
              }
              break;
            case UserRole.admin:
              // Admin allowed broadly
              break;
          }
        }
        if (!allow) {
          return MaterialPageRoute(
            builder: (_) => const ModularNavigationPage(),
          );
        }
        return null;
      },
    );
  }
}
