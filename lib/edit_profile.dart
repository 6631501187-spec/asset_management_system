import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'services/user_session.dart';
import 'services/api_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  String _currentImageUrl = AppConstants.defaultProfileImageUrl;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userId = UserSession.getCurrentUserId();
    if (userId == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.get('/user/$userId');
      if (response != null) {
        setState(() {
          usernameController.text = response['username'] ?? '';
          _currentImageUrl = response['profile_image'] ?? AppConstants.defaultProfileImageUrl;
          imageUrlController.text = response['profile_image'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    final userId = UserSession.getCurrentUserId();
    if (userId == null) return;

    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updateData = {
        'username': usernameController.text.trim(),
        'profile_image': imageUrlController.text.trim().isEmpty 
            ? null 
            : imageUrlController.text.trim(),
      };

      await ApiService.put('/user/$userId', updateData);
      
      // Update session with new data
      final currentUser = UserSession.getCurrentUser();
      if (currentUser != null) {
        currentUser['username'] = usernameController.text.trim();
        // Always update profile_image, even if null (to clear it)
        currentUser['profile_image'] = imageUrlController.text.trim().isEmpty 
            ? null 
            : imageUrlController.text.trim();
      }

      setState(() {
        _isSaving = false;
      });

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _previewImage() {
    if (imageUrlController.text.trim().isNotEmpty) {
      setState(() {
        _currentImageUrl = imageUrlController.text.trim();
      });
    } else {
      setState(() {
        _currentImageUrl = AppConstants.defaultProfileImageUrl;
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
        Navigator.of(context).pop(); // Go back to previous page
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(15, 22, 28, 1), Color(0xFF3E6079)],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Center and clamp the card to max 400 width
                        Align(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(69, 104, 130, 1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color.fromARGB(137, 141, 252, 89),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 208, 138),
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  // Profile Image Preview
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: const Color(0xFF2E4057),
                                    backgroundImage: NetworkImage(_currentImageUrl),
                                  ),
                                  const SizedBox(height: 20),

                                  // Username TextField
                                  TextField(
                                    controller: usernameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      labelStyle: const TextStyle(color: Colors.white70),
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 15),
                                      filled: true,
                                      fillColor: const Color.fromARGB(168, 15, 22, 28),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightGreenAccent),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Image URL TextField
                                  TextField(
                                    controller: imageUrlController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Profile Image URL (optional)',
                                      hintText: 'https://example.com/image.jpg',
                                      hintStyle: const TextStyle(color: Colors.white38),
                                      labelStyle: const TextStyle(color: Colors.white70),
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 15),
                                      filled: true,
                                      fillColor: const Color.fromARGB(168, 15, 22, 28),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.lightGreenAccent),
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
                                  const SizedBox(height: 25),

                                  // Action Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(255, 204, 89, 89),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            elevation: 2,
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                        width: 120,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: _isSaving ? null : _saveProfile,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(255, 89, 144, 204),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            elevation: 2,
                                          ),
                                          child: _isSaving
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}