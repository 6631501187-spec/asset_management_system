import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'std_status.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'std_home.dart';
import 'services/history_service.dart';
import 'services/user_session.dart';

class StdHistory extends StatefulWidget {
  const StdHistory({super.key});

  @override
  State<StdHistory> createState() => _StdHistoryState();
}

class _StdHistoryState extends State<StdHistory> {
  Map<String, List<Map<String, dynamic>>> historyData = {};
  bool _isLoading = true;
  String? _currentUsername;
  String? _currentProfileImage;

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    _loadUserHistory();
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

  Future<void> _loadUserHistory() async {
    final userId = UserSession.getCurrentUserId();
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User session not found. Please login again.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      final history = await HistoryService.getUserHistory(userId);
      
      // Group history by date
      final Map<String, List<Map<String, dynamic>>> groupedHistory = {};
      
      for (var item in history) {
        // Parse the date and format it consistently
        final borrowedDate = item['borrowed_date']?.toString() ?? '';
        final date = _extractDate(borrowedDate);
        final formattedDate = _formatDate(date);
        
        if (!groupedHistory.containsKey(formattedDate)) {
          groupedHistory[formattedDate] = [];
        }
        
        // Extract and format return date
        final returnDateStr = item['return_date']?.toString() ?? '';
        final returnDate = returnDateStr.isNotEmpty ? _extractDate(returnDateStr) : 'N/A';
        
        groupedHistory[formattedDate]!.add({
          'item': item['asset_name'] ?? 'Unknown Asset',
          'status': item['status'] ?? 'Unknown',
          'approver': item['approver_name'] ?? 'Unknown',
          'borrowDate': date,
          'returnDate': returnDate,
          'rejectReason': item['reject_reason'] ?? '',
          'image': item['image_src'] ?? 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=No+Image',
        });
      }
      
      setState(() {
        historyData = groupedHistory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading history: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load history: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Extract date only from datetime string (handles both ISO format and simple date)
  String _extractDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      // Parse ISO datetime or simple date and convert to local
      final date = DateTime.parse(dateStr).toLocal();
      // Return as YYYY-MM-DD
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      // If parsing fails, try to extract date from string
      return dateStr.split(' ')[0].split('T')[0];
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
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
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
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
                    MaterialPageRoute(
                      builder: (context) => const StdHome(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_edu, color: Colors.white),
                title: const Text('Check Status', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StdStatus(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_toggle_off, color: Colors.white),
                title: const Text('Borrowing History',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
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
      ),
      appBar: AppBar(
        title: const Text('Borrowing History'),
        backgroundColor: const Color.fromARGB(255, 15, 22, 28),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    _currentProfileImage ?? AppConstants.defaultProfileImageUrl,
                  ),
                  radius: 16,
                ),
                const SizedBox(height: 4),
                Text(_currentUsername ?? 'username', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F161C),
                Color(0xFF456882),
              ],
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
              : historyData.isEmpty
                  ? const Center(
                      child: Text(
                        'No borrowing history found',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: historyData.entries.map((entry) {
              final date = entry.key;
              final items = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: items.map((item) {
                      final status = item['status'];
                      final isApproved = status == 'Approved' || status == 'Returned';
                      final isRejected = status == 'Rejected';

                      final bgColor = isApproved
                          ? Colors.greenAccent.shade100
                          : Colors.redAccent.shade100;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text side (expands)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['item'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Status: ${item['status']}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    Text(
                                      'Lecturer: ${item['approver']}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    if (isRejected && item['rejectReason'] != null && item['rejectReason'].toString().isNotEmpty)
                                      Text(
                                        'Reject Reason: ${item['rejectReason']}',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    Text(
                                      'Borrow date: ${item['borrowDate']}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    if (!isRejected)
                                      Text(
                                        'Return date: ${item['returnDate']}',
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Fixed 100x100 image on the right
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image'] as String,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              );
                      }).toList(),
                    ),
        ),
      ),
    );
  }
}