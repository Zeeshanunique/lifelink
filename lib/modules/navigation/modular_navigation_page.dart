import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/pages/modular_home_page.dart';
import '../hospital_management/pages/hospital_list_page.dart';
import '../organ_donor_management/pages/donor_list_page.dart';
import '../patient_management/pages/patient_list_page.dart';
import '../appointment_management/pages/appointment_list_page.dart';

class ModularNavigationPage extends ConsumerStatefulWidget {
  const ModularNavigationPage({super.key});

  @override
  ConsumerState<ModularNavigationPage> createState() =>
      _ModularNavigationPageState();
}

class _ModularNavigationPageState extends ConsumerState<ModularNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ModularHomePage(),
    const HospitalListPage(),
    const DonorListPage(),
    const PatientListPage(),
    const AppointmentListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2F80ED),
          unselectedItemColor: const Color(0xFF9CA3AF),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined, size: 24),
              activeIcon: Icon(Icons.local_hospital, size: 24),
              label: 'Hospitals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline, size: 24),
              activeIcon: Icon(Icons.favorite, size: 24),
              label: 'Donors',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 24),
              activeIcon: Icon(Icons.people, size: 24),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: 24),
              activeIcon: Icon(Icons.calendar_today, size: 24),
              label: 'Appointments',
            ),
          ],
        ),
      ),
    );
  }
}
