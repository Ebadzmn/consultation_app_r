import 'package:consultant_app/core/network/dio_client.dart';
import 'package:consultant_app/core/network/api_client.dart';
import '../models/available_work_dates_model.dart';
import '../models/expert_model.dart';
import '../models/client_appointment_model.dart';
import '../models/expert_appointment_model.dart';
import '../../domain/entities/available_work_dates_entity.dart';
import '../../domain/entities/expert_profile.dart';
import '../../domain/entities/expert_consultations_overview.dart';

abstract class ExpertsRemoteDataSource {
  Future<List<ExpertModel>> getExperts({
    int page,
    int pageSize,
  });
  Future<ExpertProfile> getExpertProfile(String expertId);
  Future<ExpertProfile> getCurrentUserProfile();
  Future<AvailableWorkDatesEntity> getAvailableWorkDates(String expertId);
  Future<List<String>> getAvailableTimeSlots(
    String expertId,
    DateTime selectedDate,
  );
  Future<List<ClientAppointmentModel>> getClientAppointments({
    required DateTime start,
    required DateTime end,
  });
  Future<ExpertConsultationsOverview> getExpertAppointments({
    required DateTime start,
    required DateTime end,
  });
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
  static const Map<int, String> _categoryNamesById = {
    1: 'ИТ',
    2: 'Финансы',
    3: 'Банки',
    4: 'Бизнес-коучинг',
    5: 'Юридические консультации',
    6: 'PR и маркетинг',
  };

  @override
  Future<ExpertProfile> getExpertProfile(String expertId) async {
    final response = await _dioClient.get(
      '${ApiClient.getExperts}/$expertId/',
    );

    final data =
        response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};

    return _mapExpertProfileFromData(data);
  }

  @override
  Future<ExpertProfile> getCurrentUserProfile() async {
    final response = await _dioClient.get(ApiClient.profile);

    final data =
        response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};

    final typeValue = data['type'];
    final isExpert = data['is_expert'] == true ||
        (typeValue is num && typeValue.toInt() == 1);

    if (isExpert) {
      return _mapExpertProfileFromData(data);
    }

    return _mapClientProfileFromData(data);
  }

  ExpertProfile _mapExpertProfileFromData(Map<String, dynamic> data) {
    final id = data['id']?.toString() ?? '';

    final firstName = (data['first_name'] ?? '').toString().trim();
    final lastName = (data['last_name'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();

    final rawAbout = (data['about'] ?? '').toString();
    final description = rawAbout
        .replaceAll(
          RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false),
          '',
        )
        .trim();

    final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
    final articlesCount = (data['article_cnt'] as num?)?.toInt() ?? 0;
    final reviewsCount = (data['reviews_cnt'] as num?)?.toInt() ?? 0;
    final hourCost = (data['hour_cost'] as num?)?.toInt() ?? 0;
    final cost = hourCost > 0 ? '$hourCost₽/hour' : '—';

    final questionsCount = (data['questions_cnt'] as num?)?.toInt() ?? 0;
    final projectsCount = (data['projects_cnt'] as num?)?.toInt() ?? 0;

    final experienceYears = (data['experience'] as num?)?.toInt();
    final experience = experienceYears != null && experienceYears > 0
        ? '$experienceYears years'
        : '';

    String education = '';
    final educationList = data['education'];
    if (educationList is List && educationList.isNotEmpty) {
      final item = educationList.first;
      if (item is Map<String, dynamic>) {
        final institution =
            (item['educational_institution'] ?? '').toString().trim();
        final type = (item['education_type'] ?? '').toString().trim();
        education = institution.isNotEmpty ? institution : type;
      }
    }

    final categories = data['categories'];
    List<String> areas = [];
    if (categories is List) {
      areas = categories
          .map((e) => e is int ? e : int.tryParse(e.toString()))
          .whereType<int>()
          .map((categoryId) => _categoryNamesById[categoryId] ?? 'Категория $categoryId')
          .toList();
    }

    final avatarUrlRaw = (data['avatar_url'] as String?)?.trim();
    final imageUrl =
        avatarUrlRaw != null && avatarUrlRaw.isNotEmpty
            ? avatarUrlRaw
            : 'https://i.pravatar.cc/300?u=$id';

    return ExpertProfile(
      id: id,
      name: fullName.isNotEmpty ? fullName : 'Expert $id',
      rating: rating,
      imageUrl: imageUrl,
      areas: areas,
      articlesCount: articlesCount,
      pollsCount: 0,
      reviewsCount: reviewsCount,
      answersCount: 0,
      education: education,
      experience: experience,
      description: description,
      cost: cost,
      researchCount: 0,
      articleListCount: articlesCount,
      questionsCount: questionsCount,
      projectsCount: projectsCount,
      projects: const [],
    );
  }

  ExpertProfile _mapClientProfileFromData(Map<String, dynamic> data) {
    final id = data['id']?.toString() ?? '';

    final firstName = (data['first_name'] ?? '').toString().trim();
    final lastName = (data['last_name'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();

    final email = (data['email'] ?? '').toString().trim();

    final avatarUrlRaw = (data['avatar_url'] as String?)?.trim();
    final imageUrl =
        avatarUrlRaw != null && avatarUrlRaw.isNotEmpty
            ? avatarUrlRaw
            : 'https://i.pravatar.cc/300?u=$id';

    return ExpertProfile(
      id: id,
      name: fullName.isNotEmpty ? fullName : email,
      rating: 0.0,
      imageUrl: imageUrl,
      areas: const [],
      articlesCount: 0,
      pollsCount: 0,
      reviewsCount: 0,
      answersCount: 0,
      education: '',
      experience: '',
      description: '',
      cost: '—',
      researchCount: 0,
      articleListCount: 0,
      questionsCount: 0,
      projectsCount: 0,
      projects: const [],
    );
  }

  @override
  Future<List<ExpertModel>> getExperts({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dioClient.get(
      ApiClient.getExperts,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data;
    final results =
        data is Map<String, dynamic> ? data['results'] : null;

    if (results is List) {
      return results
          .whereType<Map<String, dynamic>>()
          .map(ExpertModel.fromJson)
          .toList();
    }

    return [];
  }

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
  Future<List<ClientAppointmentModel>> getClientAppointments({
    required DateTime start,
    required DateTime end,
  }) async {
    String format(DateTime dt) {
      return '${dt.year.toString().padLeft(4, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')}T'
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:'
          '${dt.second.toString().padLeft(2, '0')}';
    }

    final response = await _dioClient.get(
      ApiClient.clientAppointments,
      queryParameters: {
        'start': format(start),
        'end': format(end),
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final appointmentsRoot = data['appointments'];
      if (appointmentsRoot is Map<String, dynamic>) {
        final asClient = appointmentsRoot['as_client'];
        if (asClient is List) {
          return asClient
              .whereType<Map<String, dynamic>>()
              .map(ClientAppointmentModel.fromJson)
              .toList();
        }
      }
    }

    return [];
  }

  @override
  Future<ExpertConsultationsOverview> getExpertAppointments({
    required DateTime start,
    required DateTime end,
  }) async {
    String format(DateTime dt) {
      return '${dt.year.toString().padLeft(4, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')}T'
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:'
          '${dt.second.toString().padLeft(2, '0')}';
    }

    final response = await _dioClient.get(
      ApiClient.expertAppointments,
      queryParameters: {
        'start': format(start),
        'end': format(end),
      },
    );

    final data = response.data;
    final appointments = <ExpertAppointmentModel>[];
    final workingSlots = <ExpertWorkingSlot>[];

    if (data is Map<String, dynamic>) {
      final appointmentsRoot = data['appointments'];
      if (appointmentsRoot is Map<String, dynamic>) {
        final asExpert = appointmentsRoot['as_expert'];
        if (asExpert is List) {
          appointments.addAll(
            asExpert
                .whereType<Map<String, dynamic>>()
                .map(ExpertAppointmentModel.fromJson),
          );
        }

        final asClient = appointmentsRoot['as_client'];
        if (asClient is List) {
          appointments.addAll(
            asClient
                .whereType<Map<String, dynamic>>()
                .map(ExpertAppointmentModel.fromJson),
          );
        }
      }

      final slots = data['working_slots'];
      if (slots is List) {
        for (final item in slots.whereType<Map<String, dynamic>>()) {
          final type = item['type']?.toString();
          if (type != 'working_hour') continue;

          final startRaw = (item['start'] as String?) ?? '';
          final endRaw = (item['end'] as String?) ?? '';
          final title = (item['title'] as String?) ?? '';

          DateTime? slotStart;
          DateTime? slotEnd;

          try {
            slotStart = DateTime.parse(startRaw.replaceFirst(' ', 'T'));
          } catch (_) {}

          try {
            slotEnd = DateTime.parse(endRaw.replaceFirst(' ', 'T'));
          } catch (_) {}

          if (slotStart != null && slotEnd != null) {
            workingSlots.add(
              ExpertWorkingSlot(
                start: slotStart,
                end: slotEnd,
                title: title,
              ),
            );
          }
        }
      }
    }

    return ExpertConsultationsOverview(
      appointments: appointments,
      workingSlots: workingSlots,
    );
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
