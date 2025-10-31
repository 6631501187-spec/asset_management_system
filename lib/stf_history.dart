import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'stf_dashboard.dart';
import 'stf_add.dart';
import 'stf_return.dart';
import 'edit_profile.dart';
import 'welcome.dart';

class HistoryStaff extends StatefulWidget {
  const HistoryStaff({super.key});

  @override
  State<HistoryStaff> createState() => _HistoryStaffState();
}

class _HistoryStaffState extends State<HistoryStaff> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> historyData = [
    {
      "date": "28/10/2025",
      "status": "Approved",
      "assetName": "Canon EOS R10",
      "borrower": "Lone",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "21/10/2025",
      "returnDate": "28/10/2025",
      "image": "https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg"
    },
    {
      "date": "28/10/2025",
      "status": "Disapproved",
      "assetName": "Macbook Air M2",
      "borrower": "User2",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "21/10/2025",
      "returnDate": "28/10/2025",
      "image": "https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg"
    },
    {
      "date": "27/10/2025",
      "status": "Approved",
      "assetName": "iPad Air 5",
      "borrower": "User3",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "20/10/2025",
      "returnDate": "27/10/2025",
      "image": "https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg"
    },
    {
      "date": "27/10/2025",
      "status": "Approved",
      "assetName": "ASUS TUF F15",
      "borrower": "User4",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "22/10/2025",
      "returnDate": "27/10/2025",
      "image": "https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg"
    },
    {
      "date": "26/10/2025",
      "status": "Disapproved",
      "assetName": "Canon EOS R10",
      "borrower": "User5",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "19/10/2025",
      "returnDate": "26/10/2025",
      "image": "https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg"
    },
    {
      "date": "26/10/2025",
      "status": "Approved",
      "assetName": "Macbook Air M2",
      "borrower": "User6",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "18/10/2025",
      "returnDate": "26/10/2025",
      "image": "https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg"
    },
    {
      "date": "25/10/2025",
      "status": "Approved",
      "assetName": "iPad Air 5",
      "borrower": "User7",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "18/10/2025",
      "returnDate": "25/10/2025",
      "image": "https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg"
    },
    {
      "date": "25/10/2025",
      "status": "Approved",
      "assetName": "ASUS TUF F15",
      "borrower": "User8",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "20/10/2025",
      "returnDate": "25/10/2025",
      "image": "https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg"
    },
    {
      "date": "24/10/2025",
      "status": "Disapproved",
      "assetName": "Canon EOS R10",
      "borrower": "User9",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "17/10/2025",
      "returnDate": "24/10/2025",
      "image": "https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg"
    },
    {
      "date": "24/10/2025",
      "status": "Approved",
      "assetName": "Macbook Air M2",
      "borrower": "User10",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "17/10/2025",
      "returnDate": "24/10/2025",
      "image": "https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg"
    },
    {
      "date": "23/10/2025",
      "status": "Approved",
      "assetName": "iPad Air 5",
      "borrower": "User11",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "16/10/2025",
      "returnDate": "23/10/2025",
      "image": "https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg"
    },
    {
      "date": "23/10/2025",
      "status": "Approved",
      "assetName": "ASUS TUF F15",
      "borrower": "User12",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "18/10/2025",
      "returnDate": "23/10/2025",
      "image": "https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg"
    },
    {
      "date": "22/10/2025",
      "status": "Disapproved",
      "assetName": "Canon EOS R10",
      "borrower": "User13",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "15/10/2025",
      "returnDate": "22/10/2025",
      "image": "https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg"
    },
  ];

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
                        image: NetworkImage(AppConstants.defaultProfileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'username',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
    List<Map<String, dynamic>> filteredData = selectedFilter == 'All'
        ? historyData
        : historyData.where((item) => item['status'] == selectedFilter).toList();

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
                  backgroundImage: NetworkImage(AppConstants.defaultProfileImageUrl),
                  radius: 16,
                ),
                const SizedBox(height: 4),
                const Text('username', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                    _buildFilterChip('Disapproved', Colors.red),
                  ],
                ),
                const SizedBox(height: 20),

                // History List grouped by date
                Expanded(
                  child: ListView(
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
    final bgColor = item['status'] == 'Approved'
        ? Colors.green[300]
        : item['status'] == 'Disapproved'
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
                    '${item['status'] == 'Approved' ? 'Approved' : 'Disapproved'} by: ${item['approvedBy']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  Text(
                    'Received by: ${item['receivedBy']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  Text(
                    'Borrow date: ${item['borrowDate']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
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