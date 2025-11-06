import 'api_service.dart';

class HistoryService {
  // Get user's borrowing history
  static Future<List<dynamic>> getUserHistory(String userId) async {
    try {
      final response = await ApiService.get('/history/$userId');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }

  // Get history filtered by approver_id (for lecturers)
  static Future<List<dynamic>> getApproverHistory(String approverId) async {
    try {
      final response = await ApiService.get('/history/approver/$approverId');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load approver history: $e');
    }
  }

  // Get all history (for lecturers and staff)
  static Future<List<dynamic>> getAllHistory() async {
    try {
      final response = await ApiService.get('/history');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load all history: $e');
    }
  }
}