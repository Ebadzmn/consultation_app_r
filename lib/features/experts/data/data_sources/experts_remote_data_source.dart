import 'package:consultant_app/core/network/dio_client.dart';
import 'package:consultant_app/core/network/api_client.dart';
import '../models/available_work_dates_model.dart';
import '../models/expert_model.dart';
import '../models/client_appointment_model.dart';
import '../models/expert_appointment_model.dart';
import '../../domain/entities/available_work_dates_entity.dart';
import '../../domain/entities/expert_profile.dart';
import '../../domain/entities/expert_consultations_overview.dart';
import '../../domain/entities/project.dart';

abstract class ExpertsRemoteDataSource {
  Future<List<ExpertModel>> getExperts({
    int page,
    int pageSize,
    double? minRating,
    List<int>? categoryIds,
    String? sortBy,
    String? search,
  });
  Future<ExpertProfile> getExpertProfile(String expertId);
  Future<ExpertProfile> getCurrentUserProfile();
  Future<AvailableWorkDatesEntity> getAvailableWorkDates(String expertId);
  Future<List<String>> getAvailableTimeSlots(
    String expertId,
    DateTime selectedDate,
  );
  Future<List<Project>> getExpertProjects(String expertId, {int? categoryId});
  Future<Map<String, dynamic>> getProjectDetails(String projectId);
  Future<List<ClientAppointmentModel>> getClientAppointments({
    required DateTime start,
    required DateTime end,
  });
  Future<ExpertConsultationsOverview> getExpertAppointments({
    required DateTime start,
    required DateTime end,
  });
  Future<String?> getScheduleTimezone();
  Future<List<Map<String, dynamic>>> getSchedule();
  Future<void> updateSchedule({required List<Map<String, dynamic>> schedule});
  Future<void> createAppointment({
    required String expertId,
    required DateTime appointmentDate,
    required String appointmentTime,
    required int categoryId,
    required String notes,
  });
  Future<void> createProject({
    required String name,
    required int year,
    required List<int> categoryIds,
    required List<int> memberIds,
    required List<String> keyResults,
    required String goals,
    required int? customerId,
    required String company,
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

  String _resolveMediaUrl(String? raw, String fallback) {
    final s = raw?.trim() ?? '';
    if (s.isEmpty) {
      return fallback;
    }
    if (s.startsWith('http://') || s.startsWith('https://')) {
      return s;
    }
    final uri = Uri.parse(ApiClient.baseUrl);
    final origin = '${uri.scheme}://${uri.host}';
    return '$origin$s';
  }

  @override
  Future<ExpertProfile> getExpertProfile(String expertId) async {
    final response = await _dioClient.get('${ApiClient.getExperts}/$expertId/');

    final data = response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};

    return _mapExpertProfileFromData(data);
  }

  @override
  Future<ExpertProfile> getCurrentUserProfile() async {
    final response = await _dioClient.get(ApiClient.profile);

    final data = response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};

    final typeValue = data['type'];
    final isExpert =
        data['is_expert'] == true ||
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

    final experience = (data['experience'] ?? '').toString();
    final age = (data['age'] as num?)?.toInt();
    final linkedinUrl = (data['linkedin_url'] ?? '').toString();
    final hhUrl = (data['hh_url'] ?? '').toString();

    String education = '';
    final educationList = data['education'];
    if (educationList is List && educationList.isNotEmpty) {
      final item = educationList.first;
      if (item is Map<String, dynamic>) {
        final institution = (item['educational_institution'] ?? '')
            .toString()
            .trim();
        final type = (item['education_type'] ?? '').toString().trim();
        education = institution.isNotEmpty ? institution : type;
      }
    }

    final categories = data['categories'];
    List<String> areas = [];
    List<int> categoryIds = [];
    if (categories is List) {
      categoryIds =
          categories
              .map((e) => e is int ? e : int.tryParse(e.toString()))
              .whereType<int>()
              .toList();
      areas =
          categoryIds
              .map(
                (categoryId) =>
                    _categoryNamesById[categoryId] ?? 'Категория $categoryId',
              )
              .toList();
    }

    final avatarUrlRaw = (data['avatar_url'] as String?)?.trim();
    final imageUrl = _resolveMediaUrl(
      avatarUrlRaw,
      'https://i.pravatar.cc/300?u=$id',
    );

    return ExpertProfile(
      id: id,
      name: fullName.isNotEmpty ? fullName : 'Expert $id',
      rating: rating,
      imageUrl: imageUrl,
      areas: areas,
      categoryIds: categoryIds,
      articlesCount: articlesCount,
      pollsCount: (data['polls_cnt'] as num?)?.toInt() ?? 0,
      reviewsCount: reviewsCount,
      answersCount: (data['answers_cnt'] as num?)?.toInt() ?? 0,
      education: education,
      experience: experience,
      linkedinUrl: linkedinUrl,
      hhUrl: hhUrl,
      age: age,
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
    final imageUrl = _resolveMediaUrl(
      avatarUrlRaw,
      'https://i.pravatar.cc/300?u=$id',
    );

    return ExpertProfile(
      id: id,
      name: fullName.isNotEmpty ? fullName : email,
      rating: 0.0,
      imageUrl: imageUrl,
      areas: const [],
      categoryIds: const [],
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
  Future<List<Project>> getExpertProjects(
    String expertId, {
    int? categoryId,
  }) async {
    final query = <String, dynamic>{};
    if (categoryId != null) {
      query['category_id'] = categoryId.toString();
    }

    final response = await _dioClient.get(
      '${ApiClient.expertProjects}/$expertId/',
      queryParameters: query.isEmpty ? null : query,
    );

    final data = response.data;

    final rawList = data is List
        ? data
        : data is Map<String, dynamic>
        ? (data['results'] ?? data['data'] ?? data['projects'])
        : null;

    if (rawList is List) {
      return rawList
          .whereType<Map<String, dynamic>>()
          .map(_mapProjectFromJson)
          .toList();
    }

    return [];
  }

  @override
  Future<Map<String, dynamic>> getProjectDetails(String projectId) async {
    final response = await _dioClient.get(
      '${ApiClient.projectDetails}/$projectId/',
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }

    return {};
  }

  Project _mapProjectFromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';

    final title = (json['name'] ?? json['title'] ?? '').toString().trim();
    final description = (json['goals'] ?? json['description'] ?? '')
        .toString()
        .trim();

    final viewsCount =
        (json['views_cnt'] as num?)?.toInt() ??
        (json['views_count'] as num?)?.toInt() ??
        0;
    final likesCount =
        (json['likes_cnt'] as num?)?.toInt() ??
        (json['likes_count'] as num?)?.toInt() ??
        0;
    final commentsCount =
        (json['comments_cnt'] as num?)?.toInt() ??
        (json['comments_count'] as num?)?.toInt() ??
        0;

    final categoriesRaw = json['category'] ?? json['categories'];
    List<String> categories = [];
    if (categoriesRaw is List) {
      if (categoriesRaw.isNotEmpty &&
          categoriesRaw.first is Map<String, dynamic>) {
        categories = categoriesRaw
            .whereType<Map<String, dynamic>>()
            .map((m) => (m['name'] ?? '').toString().trim())
            .where((name) => name.isNotEmpty)
            .toList();
      } else {
        categories = categoriesRaw
            .map((e) => e is int ? e : int.tryParse(e.toString()))
            .whereType<int>()
            .map(
              (categoryId) =>
                  _categoryNamesById[categoryId] ?? 'Категория $categoryId',
            )
            .toList();
      }
    }

    List<String> participantAvatars = [];
    int additionalParticipantsCount = 0;

    final teamPreview = json['team_preview'];
    if (teamPreview is Map<String, dynamic>) {
      final topAvatars = teamPreview['top_avatars'];
      if (topAvatars is List) {
        final avatarMaps = topAvatars
            .whereType<Map<String, dynamic>>()
            .toList();
        participantAvatars = avatarMaps
            .map((m) => (m['avatar'] as String?)?.trim())
            .whereType<String>()
            .where((url) => url.isNotEmpty)
            .map(
              (url) => _resolveMediaUrl(
                url,
                'https://i.pravatar.cc/150?u=${id}_member',
              ),
            )
            .take(3)
            .toList();

        final totalCountRaw =
            teamPreview['count'] ??
            teamPreview['team_size'] ??
            teamPreview['members_count'];
        int? totalCount;
        if (totalCountRaw is num) {
          totalCount = totalCountRaw.toInt();
        } else if (totalCountRaw is String) {
          totalCount = int.tryParse(totalCountRaw);
        }
        totalCount ??= avatarMaps.length;

        if (totalCount > participantAvatars.length) {
          additionalParticipantsCount = totalCount - participantAvatars.length;
        }
      }
    } else {
      final members = json['members'];
      if (members is List) {
        final memberMaps = members.whereType<Map<String, dynamic>>().toList();
        if (memberMaps.isNotEmpty) {
          participantAvatars = memberMaps
              .map((m) => (m['avatar_url'] as String?)?.trim())
              .whereType<String>()
              .where((url) => url.isNotEmpty)
              .map(
                (url) => _resolveMediaUrl(
                  url,
                  'https://i.pravatar.cc/150?u=${id}_member',
                ),
              )
              .take(3)
              .toList();
          if (memberMaps.length > participantAvatars.length) {
            additionalParticipantsCount =
                memberMaps.length - participantAvatars.length;
          }
        } else {
          final totalMembers = members.length;
          additionalParticipantsCount = totalMembers > 3 ? totalMembers - 3 : 0;
          final placeholdersCount = totalMembers >= 3 ? 3 : totalMembers;
          participantAvatars = List.generate(
            placeholdersCount,
            (index) => 'https://i.pravatar.cc/150?u=${id}_member_$index',
          );
        }
      }
    }

    DateTime date = DateTime.now();
    final createdAt =
        json['time_create'] ??
        json['created_at'] ??
        json['updated_at'] ??
        json['year'];
    if (createdAt != null) {
      final s = createdAt.toString();
      final parsed = DateTime.tryParse(s);
      if (parsed != null) {
        date = parsed;
      }
    }

    return Project(
      id: id,
      title: title.isNotEmpty ? title : 'Project $id',
      description: description,
      participantAvatars: participantAvatars,
      additionalParticipantsCount: additionalParticipantsCount,
      commentsCount: commentsCount,
      viewsCount: viewsCount,
      likesCount: likesCount,
      categories: categories,
      date: date,
    );
  }

  @override
  Future<List<ExpertModel>> getExperts({
    int page = 1,
    int pageSize = 10,
    double? minRating,
    List<int>? categoryIds,
    String? sortBy,
    String? search,
  }) async {
    final query = <String, dynamic>{'page': page, 'page_size': pageSize};
    if (minRating != null) {
      query['min_rating'] = minRating;
    }
    if (categoryIds != null && categoryIds.isNotEmpty) {
      query['category'] = categoryIds.first;
    }
    if (sortBy != null && sortBy.trim().isNotEmpty) {
      query['sort_by'] = sortBy.trim();
    }
     if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    final response = await _dioClient.get(
      ApiClient.getExperts,
      queryParameters: query,
    );

    final data = response.data;
    final results = data is Map<String, dynamic> ? data['results'] : null;

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
      queryParameters: {'expert_id': expertId, 'selected_date': formattedDate},
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
      queryParameters: {'start': format(start), 'end': format(end)},
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
      queryParameters: {'start': format(start), 'end': format(end)},
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
            asExpert.whereType<Map<String, dynamic>>().map(
              ExpertAppointmentModel.fromJson,
            ),
          );
        }

        final asClient = appointmentsRoot['as_client'];
        if (asClient is List) {
          appointments.addAll(
            asClient.whereType<Map<String, dynamic>>().map(
              ExpertAppointmentModel.fromJson,
            ),
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
              ExpertWorkingSlot(start: slotStart, end: slotEnd, title: title),
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
  Future<String?> getScheduleTimezone() async {
    final response = await _dioClient.get(ApiClient.scheduleTimezone);

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final value = data['timezone'];
      if (value != null) {
        final s = value.toString().trim();
        if (s.isNotEmpty) {
          return s;
        }
      }
    }

    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getSchedule() async {
    final response = await _dioClient.get(ApiClient.schedule);
    final data = response.data;
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().toList();
    }
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) {
        return inner.whereType<Map<String, dynamic>>().toList();
      }
    }
    return [];
  }

  @override
  Future<void> updateSchedule({
    required List<Map<String, dynamic>> schedule,
  }) async {
    await _dioClient.post(ApiClient.schedule, data: schedule);
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

    final timeWithSeconds = appointmentTime.length == 5
        ? '$appointmentTime:00'
        : appointmentTime;

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

  @override
  Future<void> createProject({
    required String name,
    required int year,
    required List<int> categoryIds,
    required List<int> memberIds,
    required List<String> keyResults,
    required String goals,
    required int? customerId,
    required String company,
  }) async {
    await _dioClient.post(
      ApiClient.createProject,
      data: {
        'name': name,
        'year': year,
        'category': categoryIds,
        'members': memberIds,
        'key_results': keyResults,
        'goals': goals,
        'customer': customerId,
        'company': company,
      },
    );
  }
}
