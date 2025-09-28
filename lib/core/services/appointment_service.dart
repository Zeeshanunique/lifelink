import '../models/appointment.dart';
import '../repositories/appointment_repository.dart';
import '../utils/result.dart';
import '../errors/failures.dart';
import 'base_service.dart';

class AppointmentService extends BaseServiceWithValidation<Appointment> {
  final AppointmentRepository _repository;

  AppointmentService(this._repository);

  @override
  Future<Result<List<Appointment>>> getAll() async {
    try {
      return await _repository.getAll();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch appointments: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Appointment>> getById(String id) async {
    try {
      return await _repository.getById(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Appointment>> create(Appointment appointment) async {
    try {
      final validationResult = await validate(appointment);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.create(appointment);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to create appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Appointment>> update(String id, Appointment appointment) async {
    try {
      final validationResult = await validate(appointment);
      if (validationResult.isFailure) {
        return Result.failure(validationResult.failure!);
      }

      return await _repository.update(id, appointment);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      return await _repository.delete(id);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Appointment>>> search(String query) async {
    try {
      return await _repository.search(query);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to search appointments: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<bool>> validate(Appointment appointment) async {
    final errors = await getValidationErrors(appointment);
    return Result.success(errors.data?.isEmpty ?? true);
  }

  @override
  Future<Result<List<String>>> getValidationErrors(
    Appointment appointment,
  ) async {
    final errors = <String>[];

    if (appointment.patientId.trim().isEmpty) {
      errors.add('Patient ID is required');
    }

    if (appointment.doctorId.trim().isEmpty) {
      errors.add('Doctor ID is required');
    }

    if (appointment.scheduledDate.isBefore(DateTime.now())) {
      errors.add('Scheduled date cannot be in the past');
    }

    if (appointment.timeSlot.trim().isEmpty) {
      errors.add('Time slot is required');
    }

    if (appointment.type.trim().isEmpty) {
      errors.add('Appointment type is required');
    }

    if (appointment.duration <= 0) {
      errors.add('Duration must be greater than 0');
    }

    return Result.success(errors);
  }

  // Appointment-specific methods
  Future<Result<List<Appointment>>> getByPatientId(String patientId) async {
    try {
      return await _repository.getByPatientId(patientId);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch appointments by patient: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Appointment>>> getByDoctorId(String doctorId) async {
    try {
      return await _repository.getByDoctorId(doctorId);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch appointments by doctor: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Appointment>>> getByHospitalId(String hospitalId) async {
    try {
      return await _repository.getByHospitalId(hospitalId);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch appointments by hospital: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Appointment>>> getByStatus(String status) async {
    try {
      return await _repository.getByStatus(status);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch appointments by status: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Appointment>>> getByDate(DateTime date) async {
    try {
      return await _repository.getByDate(date);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch appointments by date: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Appointment>>> getTodayAppointments() async {
    try {
      return await _repository.getTodayAppointments();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch today\'s appointments: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Appointment>>> getUpcomingAppointments() async {
    try {
      return await _repository.getUpcomingAppointments();
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch upcoming appointments: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<Appointment>>> getEmergencyAppointments() async {
    try {
      return await _repository.getEmergencyAppointments();
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch emergency appointments: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<Map<String, int>>> getAppointmentStatistics(
    String hospitalId,
  ) async {
    try {
      return await _repository.getAppointmentStatistics(hospitalId);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to fetch appointment statistics: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<List<Appointment>>> getAvailableTimeSlots(
    String doctorId,
    DateTime date,
  ) async {
    try {
      return await _repository.getAvailableTimeSlots(doctorId, date);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch available time slots: ${e.toString()}'),
      );
    }
  }

  Future<Result<bool>> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    String timeSlot,
  ) async {
    try {
      return await _repository.isTimeSlotAvailable(doctorId, date, timeSlot);
    } catch (e) {
      return Result.failure(
        ServerFailure(
          'Failed to check time slot availability: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<Appointment>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTimeSlot,
  ) async {
    try {
      return await _repository.rescheduleAppointment(
        appointmentId,
        newDate,
        newTimeSlot,
      );
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to reschedule appointment: ${e.toString()}'),
      );
    }
  }

  Future<Result<Appointment>> cancelAppointment(
    String appointmentId,
    String reason,
  ) async {
    try {
      return await _repository.cancelAppointment(appointmentId, reason);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to cancel appointment: ${e.toString()}'),
      );
    }
  }

  Future<Result<Appointment>> completeAppointment(
    String appointmentId,
    Map<String, dynamic> completionData,
  ) async {
    try {
      return await _repository.completeAppointment(
        appointmentId,
        completionData,
      );
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to complete appointment: ${e.toString()}'),
      );
    }
  }

  // Additional methods needed by providers
  Future<Result<List<Appointment>>> getTodaysAppointments() async {
    return getTodayAppointments();
  }

  Future<Result<List<Appointment>>> searchAppointments(String query) async {
    return search(query);
  }
}
