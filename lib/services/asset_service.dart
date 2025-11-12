import 'api_service.dart';

class AssetService {
  // Get all available assets
  static Future<List<dynamic>> getAvailableAssets() async {
    try {
      final response = await ApiService.get('/assets');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load assets: $e');
    }
  }

  // Get all assets (for staff management)
  static Future<List<dynamic>> getAllAssets() async {
    try {
      final response = await ApiService.get('/assets/all');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load all assets: $e');
    }
  }
}
