import 'package:consultant_app/core/network/dio_client.dart';
import '../models/available_work_dates_model.dart';
import '../../domain/entities/available_work_dates_entity.dart';

abstract class ExpertsRemoteDataSource {
  Future<AvailableWorkDatesEntity> getAvailableWorkDates(String expertId);
  Future<List<String>> getAvailableTimeSlots(
    String expertId,
    DateTime selectedDate,
  );
  Future<void> createAppointment({
    required String expertId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int categoryId,
    required String notes,
  });
}

class ExpertsRemoteDataSourceImpl implements ExpertsRemoteDataSource {
  final DioClient _dioClient;

  ExpertsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AvailableWorkDatesEntity> getAvailableWorkDates(
    String expertId,
  ) async {
    final response = await _dioClient.get(
      '/appointment/available/workdates/',
      queryParameters: {'expert_id': expertId},
    );

    final data = response.data is Map<String, dynamic> ? response.data : {};

    final payload = data.containsKey('start') ? data : (data['data'] ?? {});

    return AvailableWorkDatesModel.fromJson(payload);
  }

  @override
  Future<List<String>> getAvailableTimeSlots(
    String expertId,
    DateTime selectedDate,
  ) async {
    final formattedDate =
        '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';

    final response = await _dioClient.get(
      '/appointment/available/timeslots/',
      queryParameters: {
        'expert_id': expertId,
        'selected_date': formattedDate,
      },
    );

    final data = response.data;
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    if (data is Map<String, dynamic>) {
      final slots = data['data'];
      if (slots is List) {
        return slots.map((e) => e.toString()).toList();
      }
    }

    return [];
  }

  @override
  Future<void> createAppointment({
    required String expertId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int categoryId,
    required String notes,
  }) async {
    final formattedDate =
        '${appointmentDate.year.toString().padLeft(4, '0')}-'
        '${appointmentDate.month.toString().padLeft(2, '0')}-'
        '${appointmentDate.day.toString().padLeft(2, '0')}';

    final timeWithSeconds =
        appointmentTime.length == 5 ? '$appointmentTime:00' : appointmentTime;

    await _dioClient.post(
      '/appointment/create/',
      data: {
        'expert_id': int.tryParse(expertId) ?? expertId,
        'appointment_date': formattedDate,
        'appointment_time': timeWithSeconds,
        'category_id': categoryId,
        'notes': notes,
      },
    );
  }
}
