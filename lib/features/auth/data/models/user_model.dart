import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.userType,
    super.avatarUrl,
    super.linkedinUrl,
    super.hhUrl,
    super.age,
    super.experience,
    super.education,
    super.rating,
    super.hourCost,
    super.projectsCount,
    super.questionsCount,
    super.articlesCount,
    super.reviewsCount,
    super.asExpertAppCount,
    super.asClientAppCount,
    super.isExpert,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      name:
          json['name'] ??
          '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      email: json['email'] ?? '',
      userType: (json['userType'] ?? json['type'] ?? '0').toString(),
      avatarUrl: json['avatar_url'],
      linkedinUrl: json['linkedin_url'],
      hhUrl: json['hh_url'],
      age: (json['age'] as num?)?.toInt(),
      experience: json['experience']?.toString(),
      education: json['education']?.toString(),
      rating: (json['rating'] ?? 0).toDouble(),
      hourCost: json['hour_cost'] ?? 0,
      projectsCount: json['projects_cnt'] ?? 0,
      questionsCount: json['questions_cnt'] ?? 0,
      articlesCount: json['article_cnt'] ?? 0,
      reviewsCount: json['reviews_cnt'] ?? 0,
      asExpertAppCount: json['as_expert_app_cnt'] ?? 0,
      asClientAppCount: json['as_client_app_cnt'] ?? 0,
      isExpert: json['is_expert'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType,
      'avatar_url': avatarUrl,
      'linkedin_url': linkedinUrl,
      'hh_url': hhUrl,
      'age': age,
      'experience': experience,
      'education': education,
      'rating': rating,
      'hour_cost': hourCost,
      'projects_cnt': projectsCount,
      'questions_cnt': questionsCount,
      'article_cnt': articlesCount,
      'reviews_cnt': reviewsCount,
      'as_expert_app_cnt': asExpertAppCount,
      'as_client_app_cnt': asClientAppCount,
      'is_expert': isExpert,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? userType,
    String? avatarUrl,
    String? linkedinUrl,
    String? hhUrl,
    int? age,
    String? experience,
    String? education,
    double? rating,
    int? hourCost,
    int? projectsCount,
    int? questionsCount,
    int? articlesCount,
    int? reviewsCount,
    int? asExpertAppCount,
    int? asClientAppCount,
    bool? isExpert,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      hhUrl: hhUrl ?? this.hhUrl,
      age: age ?? this.age,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      rating: rating ?? this.rating,
      hourCost: hourCost ?? this.hourCost,
      projectsCount: projectsCount ?? this.projectsCount,
      questionsCount: questionsCount ?? this.questionsCount,
      articlesCount: articlesCount ?? this.articlesCount,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      asExpertAppCount: asExpertAppCount ?? this.asExpertAppCount,
      asClientAppCount: asClientAppCount ?? this.asClientAppCount,
      isExpert: isExpert ?? this.isExpert,
    );
  }
}
