import 'api_service.dart';

class AuthService {
  // Login user
  static Future<Map<String, dynamic>> login(String userId, String password) async {
    try {
      final response = await ApiService.post('/login', {
        'user_id': userId,
        'password': password,
      });
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Register user
  static Future<Map<String, dynamic>> register(String userId, String username, String password, {String role = 'Student'}) async {
    try {
      final response = await ApiService.post('/register', {
        'user_id': userId,
        'username': username,
        'password': password,
        'role': role,
      });
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}