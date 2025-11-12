import 'package:flutter/material.dart';
import 'lec_dashboard.dart';
import 'lec_request.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'constants/app_constants.dart';
import 'services/user_session.dart';
import 'services/history_service.dart';

class LecturerHistoryPage extends StatefulWidget {
  const LecturerHistoryPage({super.key});

  @override
  State<LecturerHistoryPage> createState() => _LecturerHistoryPageState();
}

class _LecturerHistoryPageState extends State<LecturerHistoryPage> {
  String? _currentUsername;
  String? _currentProfileImage;
  Map<String, List<Map<String, dynamic>>> historyData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadLecturerHistory();
  }

  void _loadUserInfo() {
    setState(() {
      _currentUsername = UserSession.getCurrentUsername();
      _currentProfileImage = UserSession.getCurrentProfileImage();
    });
  }

  Future<void> _loadLecturerHistory() async {
    final approverId = UserSession.getCurrentUserId();
    if (approverId == null) return;

    try {
      final history = await HistoryService.getApproverHistory(approverId);
      
      // Group history by date
      final Map<String, List<Map<String, dynamic>>> groupedHistory = {};
      
      for (var item in history) {
        final borrowedDate = item['borrowed_date']?.toString() ?? '';
        final date = _extractDate(borrowedDate);
        final formattedDate = _formatDate(date);
        
        if (!groupedHistory.containsKey(formattedDate)) {
          groupedHistory[formattedDate] = [];
        }
        
        final returnDateStr = item['return_date']?.toString() ?? '';
        final returnDate = returnDateStr.isNotEmpty ? _extractDate(returnDateStr) : 'N/A';
        
        groupedHistory[formattedDate]!.add({
          'assetName': item['asset_name'] ?? 'Unknown Asset',
          'borrower': item['borrower_name'] ?? 'Unknown',
          'requestDate': date,
          'returnDate': returnDate,
          'status': item['status'] ?? 'Unknown',
          'approved': item['status'] == 'Approved' || item['status'] == 'Returned',
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load history: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Extract date only from datetime string (handles both ISO format and simple date)
  String _extractDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
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

  String _formatShortDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A47),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Lecturer History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
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
                const SizedBox(width: 8),
                Text(
                  _currentUsername ?? 'username',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
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
                    MaterialPageRoute(builder: (_) => const LecDashboard()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.inbox, color: Colors.white),
                title: const Text('Check requests', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LecturerRequestsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: const Text('History', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A47), Color(0xFF2C4E5A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // History Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: 300,
                  height: 45,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Scrollable history list grouped by date
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : historyData.isEmpty
                        ? const Center(
                            child: Text(
                              'No history available',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: historyData.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildDateSection(
                                  entry.key,
                                  entry.value.map((item) => _HistoryRecord(
                                    assetName: item['assetName'],
                                    borrower: item['borrower'],
                                    requestDate: _formatShortDate(item['requestDate']),
                                    returnDate: _formatShortDate(item['returnDate']),
                                    status: item['status'],
                                    approved: item['approved'],
                                    rejectReason: item['rejectReason'] ?? '',
                                    image: item['image'],
                                  )).toList(),
                                ),
                              );
                            }).toList(),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(String date, List<_HistoryRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...records.map((record) => _HistoryCard(record: record)).toList(),
      ],
    );
  }
}

/// ---------------- History Card ----------------
class _HistoryCard extends StatelessWidget {
  final _HistoryRecord record;
  const _HistoryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.assetName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Borrower: ${record.borrower}',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
                const SizedBox(height: 4),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: record.approved ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    record.approved ? 'Approved' : 'Disapproved',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (!record.approved && record.rejectReason.isNotEmpty)
                  Text(
                    'Reject Reason: ${record.rejectReason}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (!record.approved && record.rejectReason.isNotEmpty)
                  const SizedBox(height: 4),
                Text(
                  'Request: ${record.requestDate}${record.approved ? ' & Return: ${record.returnDate}' : ''}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right side - Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              record.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- Model ----------------
class _HistoryRecord {
  final String assetName;
  final String borrower;
  final String requestDate;
  final String returnDate;
  final String status;
  final bool approved;
  final String rejectReason;
  final String image;

  _HistoryRecord({
    required this.assetName,
    required this.borrower,
    required this.requestDate,
    required this.returnDate,
    required this.status,
    required this.approved,
    required this.rejectReason,
    required this.image,
  });
}