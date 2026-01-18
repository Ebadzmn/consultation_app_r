class ApiClient {
  // Base URL
  static const String baseUrl = 'https://websmartcons.com/api';

  // Auth Endpoints
  static const String login = '/login/';
  static const String register = '/register/';
  static const String logout = '/logout';
  static const String resetPassword = '/reset-password';
  static const String verifyOtp = '/verify-otp';
  static const String refreshToken = '/token/refresh/';
  static const String profile = '/profile/';

  // Training & Nutrition
  static const String trainingHistory = '/training/history';
  static const String nutritionPlan = '/nutrition/plan';
  static const String trackMeals = '/nutrition/track-meals';

  // Experts
  static const String getExperts = '/experts';

  // Categories
  static const String categories = '/categories/';

  // Add other endpoints here as needed
}
