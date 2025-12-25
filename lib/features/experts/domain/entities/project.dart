import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> participantAvatars;
  final int additionalParticipantsCount;
  final int commentsCount;
  final DateTime date;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.participantAvatars,
    required this.additionalParticipantsCount,
    required this.commentsCount,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        participantAvatars,
        additionalParticipantsCount,
        commentsCount,
        date,
      ];
}
