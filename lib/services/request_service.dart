import 'api_service.dart';

class RequestService {
  // Get all pending requests (for lecturers/staff)
  static Future<List<dynamic>> getAllPendingRequests() async {
    try {
      final response = await ApiService.get('/requests');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  // Get user's requests (pending and borrowed)
  static Future<List<dynamic>> getUserRequests(String userId) async {
    try {
      final response = await ApiService.get('/requests/$userId');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  // Create new asset request
  static Future<Map<String, dynamic>> createRequest(String assetId, String userId) async {
    try {
      final response = await ApiService.post('/requests', {
        'asset_id': assetId,
        'user_id': userId,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  // Approve a request (lecturer action)
  static Future<Map<String, dynamic>> approveRequest(String requestId, String approverId) async {
    try {
      final response = await ApiService.put('/requests/$requestId', {
        'action': 'approve',
        'approver_id': approverId,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to approve request: $e');
    }
  }

  // Reject a request (lecturer action)
  static Future<Map<String, dynamic>> rejectRequest(String requestId, String approverId, String rejectReason) async {
    try {
      final response = await ApiService.put('/requests/$requestId', {
        'action': 'reject',
        'approver_id': approverId,
        'reject_reason': rejectReason,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to reject request: $e');
    }
  }

  // Return asset (student action - marks request as Returned)
  static Future<Map<String, dynamic>> returnAsset(String requestId) async {
    try {
      final response = await ApiService.put('/requests/$requestId', {
        'action': 'return',
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to return asset: $e');
    }
  }

  // Get all returned requests (for staff return page)
  static Future<List<dynamic>> getReturnedRequests() async {
    try {
      final response = await ApiService.get('/requests/returned/all');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load returned requests: $e');
    }
  }

  // Confirm return (staff action - updates history and deletes request)
  static Future<Map<String, dynamic>> confirmReturn(String requestId, String staffId) async {
    try {
      final response = await ApiService.put('/requests/$requestId', {
        'action': 'confirm_return',
        'staff_id': staffId,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to confirm return: $e');
    }
  }
}
