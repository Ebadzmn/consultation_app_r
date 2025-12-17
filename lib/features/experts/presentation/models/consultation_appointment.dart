import 'package:equatable/equatable.dart';

enum ConsultationStatus { paid, needToPay, completed }

class ConsultationAppointment extends Equatable {
  final String id;
  final String expertName;
  final String expertAvatarUrl;
  final DateTime dateTime;
  final ConsultationStatus status;
  final bool hasUnreadMessages;

  const ConsultationAppointment({
    required this.id,
    required this.expertName,
    required this.expertAvatarUrl,
    required this.dateTime,
    required this.status,
    this.hasUnreadMessages = false,
  });

  @override
  List<Object?> get props => [
        id,
        expertName,
        expertAvatarUrl,
        dateTime,
        status,
        hasUnreadMessages,
      ];
}

