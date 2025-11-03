import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'std_home.dart';
import 'std_history.dart';
import 'edit_profile.dart';
import 'welcome.dart';

class StdStatus extends StatefulWidget {
  const StdStatus({super.key});

  @override
  State<StdStatus> createState() => _StdStatusState();
}

class _StdStatusState extends State<StdStatus> {
  // Sample data with different statuses
  final List<Map<String, dynamic>> borrowedItems = [
    {
      'name': 'Gaming Mouse',
      'status': 'pending',
      'requestDate': '10/22/2025',
      'returnDate': '12/22/2025',
      'image': 'https://cdn.thewirecutter.com/wp-content/media/2023/01/gamingmouse-2048px-logitech-g502x-plus-top.jpg',
    },
    {
      'name': 'iPad Air 5',
      'status': 'borrowed',
      'requestDate': '10/15/2025',
      'returnDate': '12/15/2025',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'name': 'Canon EOS R10',
      'status': 'pending',
      'requestDate': '10/20/2025',
      'returnDate': '12/20/2025',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'name': 'MacBook Air M2',
      'status': 'borrowed',
      'requestDate': '10/18/2025',
      'returnDate': '12/18/2025',
      'image': 'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
    },
    {
      'name': 'ASUS TUF F15',
      'status': 'pending',
      'requestDate': '10/25/2025',
      'returnDate': '12/25/2025',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
    },
    {
      'name': 'Sony A7C',
      'status': 'returned',
      'requestDate': '10/10/2025',
      'returnDate': '11/10/2025',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/69a3da6bcd95df779892f4b24fa6a6f7/s/o/sony-a7c_1.png',
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StdHistory()),
                  );
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
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage(AppConstants.defaultProfileImageUrl),
                  radius: 16,
                ),
                SizedBox(width: 8),
                Text('username', style: TextStyle(fontSize: 14)),
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
          child: borrowedItems.isEmpty
              ? const Center(
                  child: Text(
                    'No borrowed items',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: borrowedItems.length,
                      itemBuilder: (context, index) {
                        final item = borrowedItems[index];
                        return _buildStatusCard(item);
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> item) {
    final String status = item['status'];
    final Color statusColor = status == 'pending' 
        ? Colors.amber 
        : status == 'borrowed' 
            ? Colors.green 
            : Colors.blue;
    final String statusText = status == 'pending' 
        ? 'Pending...' 
        : status == 'borrowed' 
            ? 'Borrowed' 
            : 'Returned';

    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: 280, // fixed card width
        height: 300, // fixed card height
        child: Card(
          color: const Color(0xFF1B3358),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity, // fill the card width (280)
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: const Color(0xFF283C45),
                      child: const Center(
                        child: Icon(Icons.inventory_2, color: Colors.white30, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Request date: ${item['requestDate']}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  'Return date: ${item['returnDate']}',
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                // Conditional Return button for borrowed status
                if (status == 'borrowed') ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => _showReturnConfirmation(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6EAAD7),
                        foregroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Return',
                        style: TextStyle(fontWeight: FontWeight.w600),
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

  void _returnItem(Map<String, dynamic> item) {
    setState(() {
      // Find and update the status instead of removing the item
      final index = borrowedItems.indexWhere((element) => element['name'] == item['name']);
      if (index != -1) {
        borrowedItems[index]['status'] = 'returned';
      }
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} has been returned successfully'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}