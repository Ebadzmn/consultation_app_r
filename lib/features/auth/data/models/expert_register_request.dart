class ExpertRegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final int userType;
  final int hourCost;
  final int experience;
  final List<int> expertCategories;

  ExpertRegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.userType,
    required this.hourCost,
    required this.experience,
    required this.expertCategories,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'user_type': userType,
      'hour_cost': hourCost,
      'experience': experience,
      'expert_categories': expertCategories,
    };
  }
}
