import '../appointment_repository.dart';
import '../../models/appointment.dart';
import '../../utils/result.dart';
import '../../errors/failures.dart';

class MockAppointmentRepository implements AppointmentRepository {
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      patientId: '1',
      doctorId: '1',
      hospitalId: '1',
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '10:00 AM',
      status: 'Scheduled',
      type: 'General Checkup',
      department: 'Internal Medicine',
      roomNumber: '101',
      notes: 'Regular checkup appointment',
      duration: 30,
    ),
    Appointment(
      id: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      patientId: '2',
      doctorId: '2',
      hospitalId: '1',
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      timeSlot: '2:00 PM',
      status: 'Scheduled',
      type: 'Follow-up',
      department: 'Cardiology',
      roomNumber: '205',
      notes: 'Follow-up for heart condition',
      duration: 45,
    ),
    Appointment(
      id: '3',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      patientId: '3',
      doctorId: '3',
      hospitalId: '2',
      scheduledDate: DateTime.now().add(const Duration(hours: 2)),
      timeSlot: '4:00 PM',
      status: 'Scheduled',
      type: 'Emergency',
      department: 'Emergency',
      roomNumber: 'ER-1',
      notes: 'Emergency consultation',
      duration: 60,
      isEmergency: true,
    ),
    Appointment(
      id: '4',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
      patientId: '1',
      doctorId: '1',
      hospitalId: '1',
      scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
      timeSlot: '9:00 AM',
      status: 'Completed',
      type: 'Consultation',
      department: 'Internal Medicine',
      roomNumber: '101',
      notes: 'Completed consultation',
      duration: 30,
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      completedBy: '1',
    ),
    Appointment(
      id: '5',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      patientId: '2',
      doctorId: '2',
      hospitalId: '1',
      scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
      timeSlot: '11:00 AM',
      status: 'Cancelled',
      type: 'Follow-up',
      department: 'Cardiology',
      roomNumber: '205',
      notes: 'Patient cancelled',
      duration: 45,
      cancellationReason: 'Patient request',
      cancelledAt: DateTime.now().subtract(const Duration(days: 2)),
      cancelledBy: '2',
    ),
  ];

  @override
  Future<Result<List<Appointment>>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_appointments);
  }

  @override
  Future<Result<Appointment>> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final appointment = _appointments.firstWhere((a) => a.id == id);
      return Result.success(appointment);
    } catch (e) {
      return Result.failure(NotFoundFailure('Appointment not found'));
    }
  }

  @override
  Future<Result<Appointment>> create(Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _appointments.add(appointment);
    return Result.success(appointment);
  }

  @override
  Future<Result<Appointment>> update(String id, Appointment appointment) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final index = _appointments.indexWhere((a) => a.id == id);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Appointment not found'));
      }
      _appointments[index] = appointment;
      return Result.success(appointment);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to update appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final index = _appointments.indexWhere((a) => a.id == id);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Appointment not found'));
      }
      _appointments.removeAt(index);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Appointment>>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final results = _appointments.where((appointment) {
      final searchLower = query.toLowerCase();
      return appointment.type.toLowerCase().contains(searchLower) ||
          appointment.status.toLowerCase().contains(searchLower) ||
          (appointment.department?.toLowerCase().contains(searchLower) ??
              false) ||
          (appointment.notes?.toLowerCase().contains(searchLower) ?? false);
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByPatientId(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments
        .where((a) => a.patientId == patientId)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByDoctorId(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) => a.doctorId == doctorId).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByHospitalId(String hospitalId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments
        .where((a) => a.hospitalId == hospitalId)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) => a.status == status).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) {
      return a.scheduledDate.year == date.year &&
          a.scheduledDate.month == date.month &&
          a.scheduledDate.day == date.day;
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getTodayAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final today = DateTime.now();
    final results = _appointments.where((a) {
      return a.scheduledDate.year == today.year &&
          a.scheduledDate.month == today.month &&
          a.scheduledDate.day == today.day;
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getUpcomingAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final results = _appointments
        .where((a) => a.scheduledDate.isAfter(now))
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getEmergencyAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) => a.isEmergency).toList();
    return Result.success(results);
  }

  @override
  Future<Result<Map<String, int>>> getAppointmentStatistics(
    String hospitalId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final hospitalAppointments = _appointments
        .where((a) => a.hospitalId == hospitalId)
        .toList();

    final stats = <String, int>{
      'total': hospitalAppointments.length,
      'scheduled': hospitalAppointments
          .where((a) => a.status == 'Scheduled')
          .length,
      'completed': hospitalAppointments
          .where((a) => a.status == 'Completed')
          .length,
      'cancelled': hospitalAppointments
          .where((a) => a.status == 'Cancelled')
          .length,
      'emergency': hospitalAppointments.where((a) => a.isEmergency).length,
    };

    return Result.success(stats);
  }

  @override
  Future<Result<List<Appointment>>> getAvailableTimeSlots(
    String doctorId,
    DateTime date,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - return some available time slots
    final timeSlots = [
      '9:00 AM',
      '10:00 AM',
      '11:00 AM',
      '2:00 PM',
      '3:00 PM',
      '4:00 PM',
    ];
    // In real implementation, this would check actual availability
    return Result.success([]);
  }

  @override
  Future<Result<bool>> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    String timeSlot,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Mock implementation - always return true for demo
    return Result.success(true);
  }

  @override
  Future<Result<Appointment>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTimeSlot,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Appointment not found'));
      }

      final appointment = _appointments[index];
      final updatedAppointment = appointment.copyWith(
        scheduledDate: newDate,
        timeSlot: newTimeSlot,
        updatedAt: DateTime.now(),
      );

      _appointments[index] = updatedAppointment;
      return Result.success(updatedAppointment);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to reschedule appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Appointment>> cancelAppointment(
    String appointmentId,
    String reason,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Appointment not found'));
      }

      final appointment = _appointments[index];
      final updatedAppointment = appointment.copyWith(
        status: 'Cancelled',
        cancellationReason: reason,
        cancelledAt: DateTime.now(),
        cancelledBy: 'system', // In real app, this would be the current user
        updatedAt: DateTime.now(),
      );

      _appointments[index] = updatedAppointment;
      return Result.success(updatedAppointment);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to cancel appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<Appointment>> completeAppointment(
    String appointmentId,
    Map<String, dynamic> completionData,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index == -1) {
        return Result.failure(NotFoundFailure('Appointment not found'));
      }

      final appointment = _appointments[index];
      final updatedAppointment = appointment.copyWith(
        status: 'Completed',
        completedAt: DateTime.now(),
        completedBy: 'system', // In real app, this would be the current user
        updatedAt: DateTime.now(),
        notes: completionData['notes'] ?? appointment.notes,
        diagnosis: completionData['diagnosis'] ?? appointment.diagnosis,
        prescription:
            completionData['prescription'] ?? appointment.prescription,
      );

      _appointments[index] = updatedAppointment;
      return Result.success(updatedAppointment);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to complete appointment: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<Appointment>>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) {
      return a.scheduledDate.isAfter(startDate) &&
          a.scheduledDate.isBefore(endDate);
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getPastAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final results = _appointments
        .where((a) => a.scheduledDate.isBefore(now))
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) => a.type == type).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByDepartment(String department) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments
        .where((a) => a.department == department)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByRoomNumber(String roomNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments
        .where((a) => a.roomNumber == roomNumber)
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getCancelledAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments
        .where((a) => a.status == 'Cancelled')
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getCompletedAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments
        .where((a) => a.status == 'Completed')
        .toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getNoShowAppointments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) => a.status == 'No Show').toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getAppointmentsByTimeSlot(
    String timeSlot,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) => a.timeSlot == timeSlot).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getAppointmentsByDoctorAndDate(
    String doctorId,
    DateTime date,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = _appointments.where((a) {
      return a.doctorId == doctorId &&
          a.scheduledDate.year == date.year &&
          a.scheduledDate.month == date.month &&
          a.scheduledDate.day == date.day;
    }).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app, this would filter by user ID
    final results = _appointments.take(5).toList();
    return Result.success(results);
  }

  @override
  Future<Result<List<Appointment>>> getPaginated({
    int page = 0,
    int limit = 10,
    String? searchQuery,
    String? sortBy,
    bool ascending = true,
    Map<String, dynamic>? filters,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final startIndex = page * limit;
    final endIndex = (startIndex + limit).clamp(0, _appointments.length);
    final results = _appointments.sublist(startIndex, endIndex);
    return Result.success(results);
  }

  @override
  Future<Result<int>> getTotalCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Result.success(_appointments.length);
  }
}

