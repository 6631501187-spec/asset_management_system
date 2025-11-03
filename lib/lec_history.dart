import 'package:flutter/material.dart';
import 'lec_dashboard.dart';
import 'lec_request.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'constants/app_constants.dart';

class LecturerHistoryPage extends StatelessWidget {
  const LecturerHistoryPage({super.key});

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
                            MaterialPageRoute(builder: (_) => Welcome()),
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
                  backgroundImage: NetworkImage(AppConstants.defaultProfileImageUrl),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                const Text('username', style: TextStyle(fontSize: 14, color: Colors.white)),
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
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDateSection('01/10/2025', [
                      _HistoryRecord(
                        assetName: 'Macbook Air M2',
                        borrower: 'User1',
                        requestDate: '21/10/25',
                        returnDate: '28/10/25',
                        approved: true,
                        image: 'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
                      ),
                      _HistoryRecord(
                        assetName: 'ASUS TUF F15',
                        borrower: 'User2',
                        requestDate: '21/10/25',
                        returnDate: '25/10/25',
                        approved: false,
                        image: 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildDateSection('01/10/2025', [
                      _HistoryRecord(
                        assetName: 'Canon EOS R10',
                        borrower: 'User1',
                        requestDate: '21/10/25',
                        returnDate: '22/10/25',
                        approved: true,
                        image: 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildDateSection('01/10/2025', [
                      _HistoryRecord(
                        assetName: 'iPad Air 5',
                        borrower: 'User1',
                        requestDate: '21/10/25',
                        returnDate: '28/10/25',
                        approved: true,
                        image: 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildDateSection('01/10/2025', [
                      _HistoryRecord(
                        assetName: 'Macbook Air M2',
                        borrower: 'User1',
                        requestDate: '21/10/25',
                        returnDate: '28/10/25',
                        approved: true,
                        image: 'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
                      ),
                    ]),
                  ],
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
                Text(
                  'Request: ${record.requestDate} & Return: ${record.returnDate}',
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
  final bool approved;
  final String image;

  _HistoryRecord({
    required this.assetName,
    required this.borrower,
    required this.requestDate,
    required this.returnDate,
    required this.approved,
    required this.image,
  });
}