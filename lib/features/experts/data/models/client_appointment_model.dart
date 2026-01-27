import '../../domain/entities/expert_entity.dart';
import 'expert_model.dart';
import '../../presentation/models/consultation_appointment.dart';

class ClientAppointmentModel extends ConsultationAppointment {
  final ExpertEntity expert;

  const ClientAppointmentModel({
    required super.id,
    required super.expertName,
    required super.expertAvatarUrl,
    required super.dateTime,
    required super.status,
    super.hasUnreadMessages,
    required this.expert,
  });

  factory ClientAppointmentModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final localized = (json['localized_appointment_datetime'] as String?) ?? '';

    DateTime dateTime;
    try {
      dateTime = DateTime.parse(
        localized.replaceFirst(' ', 'T'),
      );
    } catch (_) {
      dateTime = DateTime.now();
    }

    final expertJson = json['expert'] as Map<String, dynamic>? ?? {};
    final expertEntity = ExpertModel.fromJson(expertJson);

    final statusRaw = json['status'] as int? ?? 0;
    final status = _mapStatus(statusRaw);

    return ClientAppointmentModel(
      id: id,
      expertName: expertEntity.name,
      expertAvatarUrl: expertEntity.avatarUrl,
      dateTime: dateTime,
      status: status,
      hasUnreadMessages: false,
      expert: expertEntity,
    );
  }

  static ConsultationStatus _mapStatus(int status) {
    switch (status) {
      case 4: // PAID
        return ConsultationStatus.paid;
      case 5: // COMPLETED
        return ConsultationStatus.completed;
      default:
        // NEW, CONFIRM, DECLINE, CANCEL -> treat as needToPay / problem
        return ConsultationStatus.needToPay;
    }
  }
}
