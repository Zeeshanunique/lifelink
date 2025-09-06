import '../models/appointment.dart';
import '../utils/result.dart';
import 'base_repository.dart';

abstract class AppointmentRepository
    extends BaseRepositoryWithPagination<Appointment> {
  Future<Result<List<Appointment>>> getByPatientId(String patientId);
  Future<Result<List<Appointment>>> getByDoctorId(String doctorId);
  @override
  Future<Result<List<Appointment>>> getByHospitalId(String hospitalId);
  Future<Result<List<Appointment>>> getByStatus(String status);
  Future<Result<List<Appointment>>> getByDate(DateTime date);
  Future<Result<List<Appointment>>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<List<Appointment>>> getTodayAppointments();
  Future<Result<List<Appointment>>> getUpcomingAppointments();
  Future<Result<List<Appointment>>> getPastAppointments();
  Future<Result<List<Appointment>>> getEmergencyAppointments();
  Future<Result<List<Appointment>>> getByType(String type);
  Future<Result<List<Appointment>>> getByDepartment(String department);
  Future<Result<List<Appointment>>> getByRoomNumber(String roomNumber);
  Future<Result<List<Appointment>>> getCancelledAppointments();
  Future<Result<List<Appointment>>> getCompletedAppointments();
  Future<Result<List<Appointment>>> getNoShowAppointments();
  Future<Result<List<Appointment>>> getAppointmentsByTimeSlot(String timeSlot);
  Future<Result<Map<String, int>>> getAppointmentStatistics(String hospitalId);
  Future<Result<List<Appointment>>> getAppointmentsByDoctorAndDate(
    String doctorId,
    DateTime date,
  );
  Future<Result<List<Appointment>>> getAvailableTimeSlots(
    String doctorId,
    DateTime date,
  );
  Future<Result<bool>> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    String timeSlot,
  );
  Future<Result<Appointment>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTimeSlot,
  );
  Future<Result<Appointment>> cancelAppointment(
    String appointmentId,
    String reason,
  );
  Future<Result<Appointment>> completeAppointment(
    String appointmentId,
    Map<String, dynamic> completionData,
  );
}
