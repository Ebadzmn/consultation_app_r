import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> participantAvatars;
  final int additionalParticipantsCount;
  final int commentsCount;
  final int viewsCount;
  final int likesCount;
  final List<String> categories;
  final DateTime date;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.participantAvatars,
    required this.additionalParticipantsCount,
    required this.commentsCount,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.categories = const [],
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
    viewsCount,
    likesCount,
    categories,
    date,
  ];
}
