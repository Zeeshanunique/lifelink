import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/service_locator.dart';
import 'modules/navigation/modular_navigation_page.dart';
import 'modules/hospital_management/pages/hospital_list_page.dart';
import 'modules/organ_donor_management/pages/donor_list_page.dart';
import 'modules/patient_management/pages/patient_list_page.dart';
import 'modules/appointment_management/pages/appointment_list_page.dart';
import 'modules/hospital_management/pages/add_hospital_page.dart';
import 'modules/organ_donor_management/pages/add_donor_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediLink - Hospital Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F80ED)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ModularNavigationPage(),
      routes: {
        '/main': (context) => const ModularNavigationPage(),
        '/hospitals': (context) => const HospitalListPage(),
        '/donors': (context) => const DonorListPage(),
        '/patients': (context) => const PatientListPage(),
        '/appointments': (context) => const AppointmentListPage(),
        '/add-hospital': (context) => const AddHospitalPage(),
        '/add-donor': (context) => const AddDonorPage(),
      },
    );
  }
}
