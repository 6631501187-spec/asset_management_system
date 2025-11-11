import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'services/user_session.dart';
import 'services/api_service.dart';

class EditAssetPage extends StatefulWidget {
  const EditAssetPage({
    super.key,
    required this.assetId,
    this.initialName = '',
    this.initialType = 'Laptop',
    this.initialStatus = 'Available',
  });

  final String assetId;
  final String initialName;
  final String initialType;
  final String initialStatus;

  @override
  State<EditAssetPage> createState() => _EditAssetPageState();
}

class _EditAssetPageState extends State<EditAssetPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  late String _type;
  late String _status;
  String _currentImageUrl = '';
  bool _isLoading = true;
  bool _isSaving = false;

  String? _currentUsername;
  String? _currentProfileImage;

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
    _loadAssetData();
  }

  Future<void> _loadUserInfo() async {
    final username = UserSession.getCurrentUsername();
    final profileImage = UserSession.getCurrentProfileImage();
    setState(() {
      _currentUsername = username;
      _currentProfileImage = profileImage;
    });
  }

  Future<void> _loadAssetData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.get('/assets/all');
      final asset = (response as List).firstWhere(
        (a) => a['asset_id'].toString() == widget.assetId,
        orElse: () => null,
      );

      if (asset != null) {
        final assetType = asset['asset_type'] ?? widget.initialType;
        final assetStatus = asset['status'] ?? widget.initialStatus;
        
        setState(() {
          _nameCtrl.text = asset['asset_name'] ?? widget.initialName;
          _descriptionCtrl.text = asset['description'] ?? '';
          // Make sure the type exists in the list, otherwise default to 'Laptop'
          _type = _types.contains(assetType) ? assetType : 'Laptop';
          // Map status to valid dropdown values (Pending assets shouldn't be editable, but just in case)
          if (assetStatus == 'Borrowed' || assetStatus == 'Pending') {
            _status = 'Available'; // Default to Available for non-editable statuses
          } else {
            _status = assetStatus;
          }
          _currentImageUrl = asset['image_src'] ?? '';
          _imageUrlController.text = asset['image_src'] ?? '';
          _isLoading = false;
        });
      } else {
        // Fallback to initial values if asset not found
        setState(() {
          _nameCtrl.text = widget.initialName;
          _type = _types.contains(widget.initialType) ? widget.initialType : 'Laptop';
          _status = widget.initialStatus == 'Borrowed' ? 'Available' : widget.initialStatus;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _nameCtrl.text = widget.initialName;
        _type = _types.contains(widget.initialType) ? widget.initialType : 'Laptop';
        _status = widget.initialStatus == 'Borrowed' ? 'Available' : widget.initialStatus;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load asset: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveAsset() async {
    if (_nameCtrl.text.trim().isEmpty || _descriptionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Asset name and description must be filled'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validation: Can only disable Available assets (or keep Disabled as Disabled)
    if (_status == 'Disabled' && widget.initialStatus != 'Available' && widget.initialStatus != 'Disabled') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Can only disable Available assets'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // For Borrowed or Pending assets, keep their original status
      final statusToSave = (widget.initialStatus == 'Borrowed' || widget.initialStatus == 'Pending')
          ? widget.initialStatus
          : _status;

      final updateData = {
        'asset_name': _nameCtrl.text.trim(),
        'asset_type': _type,
        'status': statusToSave,
        'description': _descriptionCtrl.text.trim(),
        'image_src': _imageUrlController.text.trim().isEmpty 
            ? null 
            : _imageUrlController.text.trim(),
      };

      await ApiService.put('/assets/${widget.assetId}', updateData);

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
            content: Text('Failed to update asset: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              'Update Successfully!',
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2430),
        foregroundColor: Colors.white,
        title: const Text('Edit Asset'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  backgroundImage: NetworkImage(_currentProfileImage ?? AppConstants.defaultProfileImageUrl),
                ),
                const SizedBox(height: 4),
                Text(_currentUsername ?? 'username', style: const TextStyle(fontSize: 12, color: Colors.white)),
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
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
                            'Edit Asset',
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

                          // Asset ID
                          Text(
                            'Asset ID: ${widget.assetId}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

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

                          // Status Dropdown (disabled if asset is Borrowed or Pending)
                          DropdownButtonFormField<String>(
                            value: _status,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              labelStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: (widget.initialStatus == 'Borrowed' || widget.initialStatus == 'Pending')
                                  ? const Color(0xFF1A2A3E) 
                                  : const Color(0xFF223A5E),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.lightGreenAccent),
                              ),
                              suffixIcon: (widget.initialStatus == 'Borrowed' || widget.initialStatus == 'Pending')
                                  ? const Icon(Icons.lock, color: Colors.white38, size: 18)
                                  : null,
                            ),
                            dropdownColor: const Color(0xFF223A5E),
                            style: TextStyle(
                              color: (widget.initialStatus == 'Borrowed' || widget.initialStatus == 'Pending')
                                  ? Colors.white38 
                                  : Colors.white,
                            ),
                            items: _statuses
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, style: const TextStyle(color: Colors.white)),
                                    ))
                                .toList(),
                            onChanged: (widget.initialStatus == 'Borrowed' || widget.initialStatus == 'Pending')
                                ? null  // Disable dropdown if borrowed or pending
                                : (v) {
                                    if (v != null) {
                                      setState(() => _status = v);
                                    }
                                  },
                            icon: Icon(
                              Icons.arrow_drop_down, 
                              color: (widget.initialStatus == 'Borrowed' || widget.initialStatus == 'Pending')
                                  ? Colors.white24 
                                  : Colors.white70,
                            ),
                            disabledHint: Text(
                              _status,
                              style: const TextStyle(color: Colors.white38),
                            ),
                          ),
                          // Show info message if status is locked
                          if (widget.initialStatus == 'Borrowed') ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Status cannot be changed while asset is borrowed',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (widget.initialStatus == 'Pending') ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Status cannot be changed while request is pending',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
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
                              onPressed: _isSaving ? null : _saveAsset,
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
    );
  }
}



