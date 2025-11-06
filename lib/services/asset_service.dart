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

  // Get all borrowed assets (for staff return page)
  static Future<List<dynamic>> getBorrowedAssets() async {
    try {
      final response = await ApiService.get('/assets/borrowed');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load borrowed assets: $e');
    }
  }

  // Return an asset (staff marks it as returned)
  static Future<void> returnAsset(int requestId, String staffId) async {
    try {
      await ApiService.put('/requests/$requestId', {
        'action': 'return',
        'staff_id': staffId,
      });
    } catch (e) {
      throw Exception('Failed to return asset: $e');
    }
  }

  // Disable an asset (staff only, must be Available)
  static Future<void> disableAsset(int assetId) async {
    try {
      await ApiService.put('/assets/$assetId/disable', {});
    } catch (e) {
      throw Exception('Failed to disable asset: $e');
    }
  }

  // Enable an asset (staff only, make Disabled -> Available)
  static Future<void> enableAsset(int assetId) async {
    try {
      await ApiService.put('/assets/$assetId/enable', {});
    } catch (e) {
      throw Exception('Failed to enable asset: $e');
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
