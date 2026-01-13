import 'package:equatable/equatable.dart';

class ProjectParticipant extends Equatable {
  final String name;
  final String avatarUrl;
  final bool isMe;

  const ProjectParticipant({
    required this.name,
    required this.avatarUrl,
    this.isMe = false,
  });

  @override
  List<Object?> get props => [name, avatarUrl, isMe];
}

class NewProjectState extends Equatable {
  final String title;
  final String description;
  final String? coverImagePath;
  final String textContent;
  final String category;
  final String company;
  final String year;
  final String results;
  final List<String> files;
  final List<ProjectParticipant> participants;
  final bool isPublishing;
  final bool publishSuccess;

  const NewProjectState({
    this.title = '',
    this.description = '',
    this.coverImagePath,
    this.textContent = '',
    this.category = '',
    this.company = '',
    this.year = '',
    this.results = '',
    this.files = const [],
    this.participants = const [],
    this.isPublishing = false,
    this.publishSuccess = false,
  });

  NewProjectState copyWith({
    String? title,
    String? description,
    String? coverImagePath,
    String? textContent,
    String? category,
    String? company,
    String? year,
    String? results,
    List<String>? files,
    List<ProjectParticipant>? participants,
    bool? isPublishing,
    bool? publishSuccess,
  }) {
    return NewProjectState(
      title: title ?? this.title,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      textContent: textContent ?? this.textContent,
      category: category ?? this.category,
      company: company ?? this.company,
      year: year ?? this.year,
      results: results ?? this.results,
      files: files ?? this.files,
      participants: participants ?? this.participants,
      isPublishing: isPublishing ?? this.isPublishing,
      publishSuccess: publishSuccess ?? this.publishSuccess,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    coverImagePath,
    textContent,
    category,
    company,
    year,
    results,
    files,
    participants,
    isPublishing,
    publishSuccess,
  ];
}
