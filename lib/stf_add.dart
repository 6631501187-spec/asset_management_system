import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'stf_dashboard.dart';
import 'stf_return.dart';
import 'stf_history.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'services/user_session.dart';
import 'services/api_service.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  String? _currentUsername;
  String? _currentProfileImage;
  
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _type = 'Laptop';
  String _status = 'Available';
  String _currentImageUrl = '';
  bool _isSaving = false;

  final _types = const [
    'Laptop',
    'Mouse',
    'Keyboard',
    'Monitor',
    'Camera',
    'Tablet',
    'Projector',
    'Adapter',
    'Storage',
    'Headphones',
    'Webcam'
  ];
  final _statuses = const ['Available', 'Disabled'];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    setState(() {
      _currentUsername = UserSession.getCurrentUsername();
      _currentProfileImage = UserSession.getCurrentProfileImage();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _previewImage() {
    if (_imageUrlController.text.trim().isNotEmpty) {
      setState(() {
        _currentImageUrl = _imageUrlController.text.trim();
      });
    } else {
      setState(() {
        _currentImageUrl = '';
      });
    }
  }

  Future<void> _handleConfirm() async {
    if (_nameCtrl.text.trim().isEmpty || _descriptionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset name and description must be filled'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final newAssetData = {
        'asset_name': _nameCtrl.text.trim(),
        'asset_type': _type,
        'status': _status,
        'description': _descriptionCtrl.text.trim(),
        'image_src': _imageUrlController.text.trim().isEmpty 
            ? null 
            : _imageUrlController.text.trim(),
      };

      await ApiService.post('/assets', newAssetData);

      setState(() {
        _isSaving = false;
      });

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add asset: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2E4057),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color.fromARGB(255, 141, 252, 89),
            width: 2,
          ),
        ),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 60),
            SizedBox(height: 10),
            Text(
              'Asset Added Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        Navigator.of(context).pop(); // Go back to dashboard
      }
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 340,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: const Color(0xFF456882),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF47FF22), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure\nyou want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE6DDD6),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B2F2F),
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          UserSession.clearSession();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) =>  Welcome()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6EAAD7),
                          foregroundColor: Colors.black,
                          elevation: 6,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Log out'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Drawer matching stf_dashboard (same structure and colors)
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF15253F),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1B3358)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF283C45),
                      image: DecorationImage(
                        image: NetworkImage(
                          _currentProfileImage ?? AppConstants.defaultProfileImageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentUsername ?? 'username',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text('Edit profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfile()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StaffDashboardPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box, color: Colors.white),
              title: const Text('Add new asset', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Current page: just close drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_return, color: Colors.white),
              title: const Text('Asset return', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReturnStaff()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryStaff()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Match std_home/stf_dashboard: dismiss keyboard when tapping outside
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E2430),
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Add Asset', style: TextStyle(fontWeight: FontWeight.w600)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      _currentProfileImage ?? AppConstants.defaultProfileImageUrl,
                    ),
                    radius: 16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUsername ?? 'username',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B3358),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Asset',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6EC1E4),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Asset Image Preview
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFF223A5E),
                            borderRadius: BorderRadius.circular(12),
                            image: _currentImageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(_currentImageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _currentImageUrl.isEmpty
                              ? const Icon(
                                  Icons.image,
                                  size: 60,
                                  color: Colors.white54,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Asset Name TextField
                      TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Asset Name',
                          labelStyle: const TextStyle(color: Colors.white70),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          filled: true,
                          fillColor: const Color(0xFF223A5E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _type,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF223A5E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          ),
                        ),
                        dropdownColor: const Color(0xFF223A5E),
                        style: const TextStyle(color: Colors.white),
                        items: _types
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: const TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _type = v!),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      
                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF223A5E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          ),
                        ),
                        dropdownColor: const Color(0xFF223A5E),
                        style: const TextStyle(color: Colors.white),
                        items: _statuses
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e, style: const TextStyle(color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _status = v!),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      
                      // Image URL TextField
                      TextField(
                        controller: _imageUrlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Image URL (optional)',
                          hintText: 'https://example.com/image.jpg',
                          hintStyle: const TextStyle(color: Colors.white38),
                          labelStyle: const TextStyle(color: Colors.white70),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          filled: true,
                          fillColor: const Color(0xFF223A5E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.preview, color: Colors.white70),
                            onPressed: _previewImage,
                            tooltip: 'Preview Image',
                          ),
                        ),
                        onChanged: (_) => _previewImage(),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Leave empty to use default image',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description TextField
                      TextField(
                        controller: _descriptionCtrl,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter additional information about the asset',
                          hintStyle: const TextStyle(color: Colors.white38),
                          labelStyle: const TextStyle(color: Colors.white70),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          filled: true,
                          fillColor: const Color(0xFF223A5E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.lightGreenAccent),
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39B54A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : () => Navigator.maybePop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD53D3D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


