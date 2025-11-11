import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'stf_dashboard.dart';
import 'stf_add.dart';
import 'stf_return.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'services/user_session.dart';
import 'services/history_service.dart';

class HistoryStaff extends StatefulWidget {
  const HistoryStaff({super.key});

  @override
  State<HistoryStaff> createState() => _HistoryStaffState();
}

class _HistoryStaffState extends State<HistoryStaff> {
  String selectedFilter = 'All';
  String? _currentUsername;
  String? _currentProfileImage;
  List<Map<String, dynamic>> historyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadAllHistory();
  }

  void _loadUserInfo() {
    setState(() {
      _currentUsername = UserSession.getCurrentUsername();
      _currentProfileImage = UserSession.getCurrentProfileImage();
    });
  }

  Future<void> _loadAllHistory() async {
    try {
      final history = await HistoryService.getAllHistory();
      
      final List<Map<String, dynamic>> formattedHistory = history.map<Map<String, dynamic>>((item) {
        final borrowedDate = item['borrowed_date']?.toString() ?? '';
        final borrowDate = _extractDate(borrowedDate);
        
        final returnDateStr = item['return_date']?.toString() ?? '';
        final returnDate = returnDateStr.isNotEmpty ? _extractDate(returnDateStr) : 'N/A';
        
        return {
          'date': _formatDate(borrowDate),
          'status': item['status'] ?? 'Unknown',
          'assetName': item['asset_name'] ?? 'Unknown Asset',
          'borrower': item['borrower_name'] ?? 'Unknown',
          'approvedBy': item['approver_name'] ?? 'Unknown',
          'receivedBy': item['staff_name'] ?? '-',
          'borrowDate': _formatDate(borrowDate),
          'returnDate': returnDate != 'N/A' ? _formatDate(returnDate) : 'N/A',
          'rejectReason': item['reject_reason'] ?? '',
          'image': item['image_src'] ?? 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=No+Image',
        };
      }).toList();
      
      setState(() {
        historyData = formattedHistory;
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAssetPage()),
                );
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

  Map<String, List<Map<String, dynamic>>> _groupByDate(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in data) {
      String date = item['date'];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData;
    
    if (selectedFilter == 'All') {
      filteredData = historyData;
    } else if (selectedFilter == 'Approved') {
      // Show both Approved and Returned statuses
      filteredData = historyData.where((item) => 
        item['status'] == 'Approved' || item['status'] == 'Returned'
      ).toList();
    } else if (selectedFilter == 'Rejected') {
      filteredData = historyData.where((item) => item['status'] == 'Rejected').toList();
    } else {
      filteredData = historyData;
    }

    Map<String, List<Map<String, dynamic>>> groupedData = _groupByDate(filteredData);

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2430),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Staff History',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Filter Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFilterChip('All', Colors.blue),
                    const SizedBox(width: 10),
                    _buildFilterChip('Approved', Colors.green),
                    const SizedBox(width: 10),
                    _buildFilterChip('Rejected', Colors.red),
                  ],
                ),
                const SizedBox(height: 20),

                // History List grouped by date
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : groupedData.isEmpty
                          ? const Center(
                              child: Text(
                                'No history available',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            )
                          : ListView(
                              children: groupedData.entries.map((entry) {
                                return _buildDateSection(entry.key, entry.value);
                              }).toList(),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(String date, List<Map<String, dynamic>> items) {
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
        ...items.map((item) => _buildHistoryCard(item)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final status = item['status'];
    final isRejected = status == 'Rejected';
    final isApproved = status == 'Approved' || status == 'Returned';
    
    final bgColor = isApproved
        ? Colors.green[300]
        : isRejected
            ? Colors.red[300]
            : Colors.grey[200];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
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
                    item['assetName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Borrowed by: ${item['borrower']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  Text(
                    '${isApproved ? 'Approved' : 'Rejected'} by: ${item['approvedBy']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  if (isRejected && item['rejectReason'] != null && item['rejectReason'].toString().isNotEmpty)
                    Text(
                      'Reject Reason: ${item['rejectReason']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (isApproved)
                    Text(
                      'Received by: ${item['receivedBy']}',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  Text(
                    'Borrow date: ${item['borrowDate']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  if (isApproved)
                    Text(
                      'Return date: ${item['returnDate']}',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right side - Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    final bool isSelected = selectedFilter == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF1B3358),
      onSelected: (_) {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }
}