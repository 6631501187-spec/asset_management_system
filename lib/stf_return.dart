import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'stf_dashboard.dart';
import 'stf_add.dart';
import 'stf_history.dart';
import 'edit_profile.dart';
import 'welcome.dart';

class ReturnStaff extends StatefulWidget {
  const ReturnStaff({super.key});

  @override
  State<ReturnStaff> createState() => _ReturnStaffState();
}

class _ReturnStaffState extends State<ReturnStaff> {

  void _showResponseDialog(BuildContext context, String message, Color borderColor) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
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
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFE6DDD6),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Auto close dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close dialog only, stay on same page
      }
    });
  }

  void _showRemarkDialog(BuildContext context, _ReturnRequestRecord asset) {
    final TextEditingController remarkController = TextEditingController();
    
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 360,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: const Color(0xFF456882),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Asset Return: ${asset.assetName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFE6DDD6),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add Remark (Optional)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE6DDD6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter any remarks about the asset condition...',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: const Color(0xFF1B3358),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          remarkController.dispose();
                          Navigator.of(ctx).pop();
                        },
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
                          final remark = remarkController.text.trim();
                          remarkController.dispose();
                          Navigator.of(ctx).pop();
                          
                          String message = 'Asset received successfully';
                          if (remark.isNotEmpty) {
                            message += '\nRemark: $remark';
                          }
                          _showResponseDialog(context, message, Colors.green);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Confirm'),
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
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2430),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Asset Return',
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
          child: Column(
            children: [
              // Return Requests Button
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
                    'Return Requests',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Scrollable list of return request cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _sampleReturnRequests.length,
                  itemBuilder: (context, i) {
                    final req = _sampleReturnRequests[i];
                    return _ReturnRequestCard(
                      record: req,
                      onReceived: () => _showRemarkDialog(context, req),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- Return Request Card ----------------
class _ReturnRequestCard extends StatelessWidget {
  final _ReturnRequestRecord record;
  final VoidCallback onReceived;

  const _ReturnRequestCard({
    required this.record,
    required this.onReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3358),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
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
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Type: ${record.assetType}',
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Borrower: ${record.borrower}',
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Borrow Date: ${record.borrowDate}',
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Return Date: ${record.returnDate}',
                      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 13),
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
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.black45),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Received button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: onReceived,
              child: const Text('Received'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- Model + Data ----------------
class _ReturnRequestRecord {
  final String assetName;
  final String assetType;
  final String borrower;
  final String borrowDate;
  final String returnDate;
  final String image;

  _ReturnRequestRecord({
    required this.assetName,
    required this.assetType,
    required this.borrower,
    required this.borrowDate,
    required this.returnDate,
    required this.image,
  });
}

final _sampleReturnRequests = <_ReturnRequestRecord>[
  _ReturnRequestRecord(
    assetName: 'Macbook Air M2',
    assetType: 'Laptop',
    borrower: 'User1',
    borrowDate: '21/10/25',
    returnDate: '28/10/25',
    image: 'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
  ),
  _ReturnRequestRecord(
    assetName: 'Canon EOS R10',
    assetType: 'Camera',
    borrower: 'User3',
    borrowDate: '21/10/25',
    returnDate: '22/10/25',
    image: 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
  ),
  _ReturnRequestRecord(
    assetName: 'iPad Air 5',
    assetType: 'Tablet',
    borrower: 'User4',
    borrowDate: '22/10/25',
    returnDate: '29/10/25',
    image: 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
  ),
  _ReturnRequestRecord(
    assetName: 'ASUS TUF F15',
    assetType: 'Laptop',
    borrower: 'User2',
    borrowDate: '21/10/25',
    returnDate: '25/10/25',
    image: 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
  ),
  _ReturnRequestRecord(
    assetName: 'Sony A7C',
    assetType: 'Camera',
    borrower: 'User5',
    borrowDate: '23/10/25',
    returnDate: '30/10/25',
    image: 'https://www.bigcamera.co.th/media/catalog/product/cache/69a3da6bcd95df779892f4b24fa6a6f7/s/o/sony-a7c_1.png',
  ),
];