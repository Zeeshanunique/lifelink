import 'package:get_it/get_it.dart';
import '../repositories/hospital_repository.dart';
import '../repositories/patient_repository.dart';
import '../repositories/organ_donor_repository.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/implementations/mock_hospital_repository.dart';
import '../repositories/implementations/mock_organ_donor_repository.dart';
import '../services/hospital_service.dart';
import '../services/organ_donor_service.dart';
import '../services/patient_service.dart';
import '../services/appointment_service.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Repositories
    getIt.registerLazySingleton<HospitalRepository>(
      () => MockHospitalRepository(),
    );
    getIt.registerLazySingleton<OrganDonorRepository>(
      () => MockOrganDonorRepository(),
    );
    getIt.registerLazySingleton<PatientRepository>(
      () => throw UnimplementedError('PatientRepository implementation needed'),
    );
    getIt.registerLazySingleton<AppointmentRepository>(
      () => throw UnimplementedError(
        'AppointmentRepository implementation needed',
      ),
    );

    // Services
    getIt.registerLazySingleton<HospitalService>(
      () => HospitalService(getIt<HospitalRepository>()),
    );
    getIt.registerLazySingleton<OrganDonorService>(
      () => OrganDonorService(getIt<OrganDonorRepository>()),
    );
    getIt.registerLazySingleton<PatientService>(
      () => PatientService(getIt<PatientRepository>()),
    );
    getIt.registerLazySingleton<AppointmentService>(
      () => AppointmentService(getIt<AppointmentRepository>()),
    );
  }
}
