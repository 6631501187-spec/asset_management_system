import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'lec_request.dart';
import 'lec_history.dart';
import 'edit_profile.dart';
import 'welcome.dart';

class LecDashboard extends StatefulWidget {
  const LecDashboard({super.key});

  @override
  State<LecDashboard> createState() => _LecDashboardState();
}

class _LecDashboardState extends State<LecDashboard> {
  // initialize the profile lists
  String? selectedStatus; // null means show all

  final List<Map<String, String>> allAssets = const [
    {
      'name': 'Canon EOS R10',
      'type': 'Camera',
      'status': 'Available',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'name': 'Sony A7C',
      'type': 'Camera',
      'status': 'Borrowed',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/69a3da6bcd95df779892f4b24fa6a6f7/s/o/sony-a7c_1.png',
    },
    {
      'name': 'iPad Air 5',
      'type': 'Tablet',
      'status': 'Disabled',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'name': 'ASUS TUF F15',
      'type': 'Laptop',
      'status': 'Available',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
    },
    {
      'name': 'Macbook Air M2',
      'type': 'Laptop',
      'status': 'Available',
      'image': 'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
    },
    {
      'name': 'Canon 50mm Lens',
      'type': 'Lens',
      'status': 'Available',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'name': 'Dell XPS 13',
      'type': 'Laptop',
      'status': 'Disabled',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
    },
    {
      'name': 'iPad Pro 11',
      'type': 'Tablet',
      'status': 'Borrowed',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'name': 'Nikon Z6',
      'type': 'Camera',
      'status': 'Available',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'name': 'HP Pavilion',
      'type': 'Laptop',
      'status': 'Available',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
    },
    {
      'name': 'Samsung Tab S8',
      'type': 'Tablet',
      'status': 'Borrowed',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
  ];

  List<Map<String, String>> get filteredAssets {
    if (selectedStatus == null) {
      return allAssets;
    }
    return allAssets.where((asset) => asset['status'] == selectedStatus).toList();
  }

  int get availableCount => allAssets.where((a) => a['status'] == 'Available').length;
  int get borrowedCount => allAssets.where((a) => a['status'] == 'Borrowed').length;
  int get disabledCount => allAssets.where((a) => a['status'] == 'Disabled').length;

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LecturerHistoryPage()),
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
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Lecturer Dashboard'),
          backgroundColor: const Color.fromRGBO(15, 22, 28, 1),
          foregroundColor: Colors.white,
          elevation: 0,
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
                  const SizedBox(height: 4),
                  const Text('username', style: TextStyle(fontSize: 12, color: Colors.white)),
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
              colors: [Color(0xFF0F161C), Color(0xFF456882)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _LecturerSearchBar(),
                  const SizedBox(height: 12),
                  _KpiRow(
                    availableCount: availableCount,
                    borrowedCount: borrowedCount,
                    disabledCount: disabledCount,
                    selectedStatus: selectedStatus,
                    onStatusTap: (status) {
                      setState(() {
                        // Toggle filter: if same status clicked, clear filter
                        selectedStatus = selectedStatus == status ? null : status;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Today',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredAssets.length,
                      itemBuilder: (context, index) {
                        final asset = filteredAssets[index];
                        return _AssetCard(
                          name: asset['name']!,
                          type: asset['type']!,
                          status: asset['status']!,
                          image: asset['image']!,
                        );
                      },
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

/* ---------------- Search Bar (StdHome style, height 40) ---------------- */
class _LecturerSearchBar extends StatefulWidget {
  @override
  State<_LecturerSearchBar> createState() => _LecturerSearchBarState();
}

class _LecturerSearchBarState extends State<_LecturerSearchBar> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _searchCtrl,
        focusNode: _searchFocus,
        decoration: InputDecoration(
          hintText: 'Search assets...',
          hintStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: const Color(0xFF1B3358),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _searchCtrl.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    setState(() {
                      _searchCtrl.clear();
                      _searchFocus.requestFocus();
                    });
                  },
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

/* ---------------- KPI Row (buttons W120 H55) ---------------- */
class _KpiRow extends StatelessWidget {
  final int availableCount;
  final int borrowedCount;
  final int disabledCount;
  final String? selectedStatus;
  final Function(String) onStatusTap;

  const _KpiRow({
    required this.availableCount,
    required this.borrowedCount,
    required this.disabledCount,
    required this.selectedStatus,
    required this.onStatusTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _KpiButton(
          title: 'Available',
          count: availableCount,
          color: Colors.green,
          isSelected: selectedStatus == 'Available',
          onTap: () => onStatusTap('Available'),
        ),
        _KpiButton(
          title: 'Borrowed',
          count: borrowedCount,
          color: Colors.orange,
          isSelected: selectedStatus == 'Borrowed',
          onTap: () => onStatusTap('Borrowed'),
        ),
        _KpiButton(
          title: 'Disabled',
          count: disabledCount,
          color: Colors.grey,
          isSelected: selectedStatus == 'Disabled',
          onTap: () => onStatusTap('Disabled'),
        ),
      ],
    );
  }
}

class _KpiButton extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _KpiButton({
    required this.title,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected ? BorderSide(color: color, width: 2) : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      title == 'Available'
                          ? Icons.check_circle
                          : title == 'Borrowed'
                              ? Icons.access_time
                              : Icons.remove_circle,
                      color: color,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(title,
                        style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    Text('$count',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
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

/* ---------------- Asset Card (background D9D9D9) ---------------- */
class _AssetCard extends StatelessWidget {
  final String name;
  final String type;
  final String status;
  final String image;

  const _AssetCard({
    required this.name,
    required this.type,
    required this.status,
    required this.image,
  });

  Color get statusColor {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Borrowed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('Type: $type', style: const TextStyle(color: Colors.black54)),
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(color: Colors.black54)),
                      Text(status,
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
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
}