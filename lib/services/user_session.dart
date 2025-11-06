class UserSession {
  static Map<String, dynamic>? _currentUser;
  static String? _token;

  // Set current user after login
  static void setCurrentUser(Map<String, dynamic> user, String token) {
    _currentUser = user;
    _token = token;
  }

  // Get current user
  static Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  // Get current user ID
  static String? getCurrentUserId() {
    return _currentUser?['user_id']?.toString();
  }

  // Get current username
  static String? getCurrentUsername() {
    return _currentUser?['username'];
  }

  // Get current profile image URL
  static String? getCurrentProfileImage() {
    return _currentUser?['profile_image'];
  }

  // Get current token
  static String? getToken() {
    return _token;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _currentUser != null && _token != null;
  }

  // Clear session (logout)
  static void clearSession() {
    _currentUser = null;
    _token = null;
  }
}