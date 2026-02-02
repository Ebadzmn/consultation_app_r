import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String userType; // Expert or Client
  final String? avatarUrl;
  final String? linkedinUrl;
  final String? hhUrl;
  final int? age;
  final String? experience;
  final String? education;
  final double rating;
  final int hourCost;
  final int projectsCount;
  final int questionsCount;
  final int articlesCount;
  final int reviewsCount;
  final int asExpertAppCount;
  final int asClientAppCount;
  final bool isExpert;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.avatarUrl,
    this.linkedinUrl,
    this.hhUrl,
    this.age,
    this.experience,
    this.education,
    this.rating = 0.0,
    this.hourCost = 0,
    this.projectsCount = 0,
    this.questionsCount = 0,
    this.articlesCount = 0,
    this.reviewsCount = 0,
    this.asExpertAppCount = 0,
    this.asClientAppCount = 0,
    this.isExpert = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    userType,
    avatarUrl,
    linkedinUrl,
    hhUrl,
    age,
    experience,
    education,
    rating,
    hourCost,
    projectsCount,
    questionsCount,
    articlesCount,
    reviewsCount,
    asExpertAppCount,
    asClientAppCount,
    isExpert,
  ];
}
