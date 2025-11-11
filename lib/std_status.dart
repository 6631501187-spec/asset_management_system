import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'std_home.dart';
import 'std_history.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'services/request_service.dart';
import 'services/user_session.dart';

class StdStatus extends StatefulWidget {
  const StdStatus({super.key});

  @override
  State<StdStatus> createState() => _StdStatusState();
}

class _StdStatusState extends State<StdStatus> {
  List<Map<String, dynamic>> borrowedItems = [];
  bool _isLoading = true;
  String? _currentUsername;
  String? _currentProfileImage;

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    _loadUserRequests();
  }

  void _checkUserSession() {
    if (!UserSession.isLoggedIn()) {
      // Redirect to login if not logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
      });
      return;
    }
    _currentUsername = UserSession.getCurrentUsername();
    _currentProfileImage = UserSession.getCurrentProfileImage();
  }

  Future<void> _loadUserRequests() async {
    final userId = UserSession.getCurrentUserId();
    if (userId == null) return;

    try {
      final requests = await RequestService.getUserRequests(userId);
      setState(() {
        // Map requests and use request status instead of asset status
        borrowedItems = requests.map((request) => {
          'req_id': request['req_id'],
          'name': request['asset_name'],
          'status': request['status']?.toString().toLowerCase() ?? 'pending', // Use request status: pending/approved/returned
          'requestDate': _formatDate(request['borrow_date']),
          'returnDate': _formatDate(request['return_date']),
          'image': request['image_src'] ?? 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=${Uri.encodeComponent(request['asset_name'])}',
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load requests: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'N/A';
    try {
      final dateStr = dateValue.toString();
      // Handle both "YYYY-MM-DD" and "YYYY-MM-DDTHH:mm:ss.sssZ" formats
      if (dateStr.contains('T')) {
        // ISO format - parse as UTC and convert to local
        final date = DateTime.parse(dateStr).toLocal();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } else {
        // Already in date format, just take the date part
        return dateStr.split(' ')[0];
      }
    } catch (e) {
      return dateValue.toString().split('T')[0].split(' ')[0];
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer (sidebar) same as StdHome
      drawer: Drawer(
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
                    // filled circular avatar
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
              // Edit Profile
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
              // Home -> navigate to StdHome
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // close drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const StdHome()),
                  );
                },
              ),
              // Check Status -> current page
              ListTile(
                leading: const Icon(Icons.history_edu, color: Colors.white),
                title: const Text('Check Status', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // just close (current page)
                },
              ),
              // Borrowing History
              ListTile(
                leading: const Icon(Icons.history_toggle_off, color: Colors.white),
                title: const Text('Borrowing History', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StdHistory()),
                  );
                  // Reload requests after returning from history page
                  _loadUserRequests();
                },
              ),
              // Logout
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
      ),

      // AppBar style same as StdHome (transparent, no shadow)
      appBar: AppBar(
        title: const Text('Request Status'),
        backgroundColor: const Color.fromARGB(255, 15, 22, 28),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    _currentProfileImage ?? AppConstants.defaultProfileImageUrl,
                  ),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Text(_currentUsername ?? 'username', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),

      // Background gradient same as StdHome + existing content
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F161C), Color(0xFF456882)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : borrowedItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No active requests',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Center(
                      // Show only the most recent request (first item after ORDER BY DESC)
                      child: _buildStatusCard(borrowedItems[0]),
                    ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> item) {
    final String status = item['status'];
    final Color statusColor;
    final String statusText;
    
    // Map request status to display
    switch (status) {
      case 'pending':
        statusColor = Colors.amber;
        statusText = 'Pending Approval';
        break;
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved (Borrowed)';
        break;
      case 'returned':
        statusColor = Colors.blue;
        statusText = 'Return Submitted';
        break;
      default:
        statusColor = Colors.grey;
        statusText = status;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: 330,
        height: 450, // slightly wider for single card
        child: Card(
          color: const Color(0xFF1B3358),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: const Color(0xFF283C45),
                      child: const Center(
                        child: Icon(Icons.inventory_2, color: Colors.white30, size: 50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: statusColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 16,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.calendar_today, 'Request date', item['requestDate']),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.event, 'Return date', item['returnDate']),
                // Show Return button only when status is 'approved'
                if (status == 'approved') ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _showReturnConfirmation(item),
                      icon: const Icon(Icons.keyboard_return, size: 18),
                      label: const Text(
                        'Return',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6EAAD7),
                        foregroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 14, color: Colors.white60),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _showReturnConfirmation(Map<String, dynamic> item) {
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
                Text(
                  'Return ${item['name']}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFE6DDD6),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Are you sure you want to return this item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE6DDD6),
                    fontSize: 16,
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
                          _returnItem(item);
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
                        child: const Text('Return'),
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

  Future<void> _returnItem(Map<String, dynamic> item) async {
    try {
      // Call the student return endpoint (action='return')
      await RequestService.returnAsset(item['req_id'].toString());
      
      // Reload the requests to reflect the updated status
      await _loadUserRequests();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Return request submitted for ${item['name']}. Waiting for staff confirmation.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to return ${item['name']}: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}