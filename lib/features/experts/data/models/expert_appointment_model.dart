import '../../presentation/models/consultation_appointment.dart';

class ExpertAppointmentModel extends ConsultationAppointment {
  const ExpertAppointmentModel({
    required super.id,
    required super.expertName,
    required super.expertAvatarUrl,
    required super.dateTime,
    required super.status,
    super.hasUnreadMessages,
  });

  factory ExpertAppointmentModel.fromJson(Map<String, dynamic> json) {
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

    final client = json['client'] as Map<String, dynamic>?;
    final clientFirst = (client?['first_name'] ?? '').toString().trim();
    final clientLast = (client?['last_name'] ?? '').toString().trim();
    final clientName = '$clientFirst $clientLast'.trim();

    final statusRaw = json['status'] as int? ?? 0;
    final status = _mapStatus(statusRaw);

    return ExpertAppointmentModel(
      id: id,
      expertName: clientName.isNotEmpty ? clientName : 'Client',
      expertAvatarUrl: 'https://i.pravatar.cc/150?u=client_$id',
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

