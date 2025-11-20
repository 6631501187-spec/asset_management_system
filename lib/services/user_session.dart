class UserSession {
  static Map<String, dynamic>? _currentUser;

  // Set current user after login
  static void setCurrentUser(Map<String, dynamic> user) {
    _currentUser = user;
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

  // Check if user is logged in
  static bool isLoggedIn() {
    return _currentUser != null;
  }

  // Clear session (logout)
  static void clearSession() {
    _currentUser = null;
  }
}