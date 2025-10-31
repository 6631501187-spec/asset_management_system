import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'stf_add.dart';
import 'stf_return.dart';
import 'stf_history.dart';
import 'stf_edit.dart';
import 'edit_profile.dart';
import 'welcome.dart';

/// =====================================================
/// Staff Dashboard (UI only, no navigation)
/// =====================================================
class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  String? selectedStatus; // null means show all

  final List<Map<String, String>> allAssets = const [
    {
      'assetId': 'CAM001',
      'name': 'Canon EOS R10',
      'type': 'Camera',
      'status': 'Available',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'assetId': 'CAM002',
      'name': 'Sony A7C',
      'type': 'Camera',
      'status': 'Borrowed',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'assetId': 'TAB001',
      'name': 'iPad Air 5',
      'type': 'Tablet',
      'status': 'Disabled',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'assetId': 'LAP001',
      'name': 'ASUS TUF F15',
      'type': 'Laptop',
      'status': 'Available',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
    },
    {
      'assetId': 'LAP002',
      'name': 'Macbook Air M2',
      'type': 'Laptop',
      'status': 'Available',
      'image': 'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
    },
    {
      'assetId': 'TAB002',
      'name': 'iPad Pro 11',
      'type': 'Tablet',
      'status': 'Borrowed',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'assetId': 'CAM003',
      'name': 'Nikon Z6',
      'type': 'Camera',
      'status': 'Available',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'assetId': 'LAP003',
      'name': 'Dell XPS 15',
      'type': 'Laptop',
      'status': 'Disabled',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
    },
    {
      'assetId': 'LAP004',
      'name': 'HP Pavilion',
      'type': 'Laptop',
      'status': 'Available',
      'image': 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
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
    // Match std_home behavior: dismiss keyboard when tapping outside
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
        ),
        backgroundColor: const Color(0xFF0E2430),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white ,
          elevation: 0,
          title: const Row(
            children: [
              SizedBox(width: 8),
              Text(
                'Staff Dashboard',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(AppConstants.defaultProfileImageUrl),
                    radius: 16,
                  ),
                  SizedBox(height: 4),
                  Text('username', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
            ),
          ),
          child: Column(
            children: [
              // Fixed top section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StaffSearchBar(),
                    const SizedBox(height: 12),
                    const _StaffFilterChips(),
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
                      child: _SectionTitle('Today'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // Scrollable cards section
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredAssets.length,
                  itemBuilder: (context, index) {
                    final asset = filteredAssets[index];
                    return _StaffAssetCard(
                      assetId: asset['assetId']!,
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
    );
  }
}

/* ========================= KPI Row ========================= */
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
            side: isSelected
                ? BorderSide(color: color, width: 2)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              children: [
                Icon(
                  title == 'Available'
                      ? Icons.check_circle
                      : title == 'Borrowed'
                          ? Icons.schedule
                          : Icons.cancel,
                  color: color,
                  size: 18,
                ),
                const SizedBox(height: 6),
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('$count',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ========================= Section Title ========================= */
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/* ========================= Staff Asset Card ========================= */
class _StaffAssetCard extends StatelessWidget {
  final String assetId;
  final String name;
  final String type;
  final String status;
  final String image;

  const _StaffAssetCard({
    required this.assetId,
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
      color: const Color(0xFF1B4F5C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image at the start
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                  Text('Type: $type', style: const TextStyle(color: Colors.white70)),
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(color: Colors.white70)),
                      Text(status,
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAssetPage(
                      assetId: assetId,
                      initialName: name,
                      initialType: type,
                      initialStatus: status,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6EAAD7),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}

// New: std_home-style search bar for staff
class _StaffSearchBar extends StatefulWidget {
  @override
  State<_StaffSearchBar> createState() => _StaffSearchBarState();
}

class _StaffSearchBarState extends State<_StaffSearchBar> {
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
    return TextField(
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
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (_) => setState(() {}),
    );
  }
}

// New: std_home-style filter chips for staff
class _StaffFilterChips extends StatelessWidget {
  const _StaffFilterChips();

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B3358),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Computer'),
          _buildFilterChip('iPad'),
          _buildFilterChip('Camera'),
          _buildFilterChip('Desk'),
        ],
      ),
    );
  }
}