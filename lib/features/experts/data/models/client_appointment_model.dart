import '../../presentation/models/consultation_appointment.dart';

class ClientAppointmentModel extends ConsultationAppointment {
  const ClientAppointmentModel({
    required super.id,
    required super.expertName,
    required super.expertAvatarUrl,
    required super.dateTime,
    required super.status,
    super.hasUnreadMessages,
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

    final expert = json['expert'] as Map<String, dynamic>?;
    final expertFirst = (expert?['first_name'] ?? '').toString().trim();
    final expertLast = (expert?['last_name'] ?? '').toString().trim();
    final expertName = '$expertFirst $expertLast'.trim();

    final statusRaw = json['status'] as int? ?? 0;
    final status = _mapStatus(statusRaw);

    return ClientAppointmentModel(
      id: id,
      expertName: expertName.isNotEmpty ? expertName : 'Expert',
      expertAvatarUrl: 'https://i.pravatar.cc/150?u=$id',
      dateTime: dateTime,
      status: status,
      hasUnreadMessages: false,
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

