/// Centralized API Configuration & Endpoints for JAROOS Backend Integration (Node.js/Express)
class ApiService {
  // Base server URL (Configurable for local emulator, real device LAN, or cloud production)
  // For Android emulator: 10.0.2.2 points to localhost of the host machine
  static const String defaultBaseUrl = 'http://10.0.2.2:5000/api';
  
  String baseUrl;

  ApiService({this.baseUrl = defaultBaseUrl});

  // Authentication Endpoints
  static const String endpointLogin = '/auth/login';
  static const String endpointRegister = '/auth/register';
  static const String endpointProfile = '/user/profile';

  // Learning Modules & Lessons Endpoints
  static const String endpointLessons = '/lessons';
  static String endpointLessonDetail(String id) => '/lessons/$id';

  // Quizzes & Progress Endpoints
  static const String endpointQuizzes = '/quizzes';
  static const String endpointQuizResult = '/quizzes/result';
  static const String endpointProgress = '/progress';
  static const String endpointAchievements = '/achievements';

  // Common Headers Builder with optional JWT Bearer token
  Map<String, String> getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
