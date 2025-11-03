import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'std_request.dart';
import 'std_status.dart';
import 'std_history.dart';
import 'edit_profile.dart';
import 'welcome.dart';

class StdHome extends StatefulWidget {
  const StdHome({super.key});

  @override
  State<StdHome> createState() => _StdHomeState();
}

class _StdHomeState extends State<StdHome> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _selectedFilter = 'All'; // Track selected filter

  // Sample asset data
  final List<Map<String, String>> allAssets = const [
    {
      'name': 'Gaming Mouse',
      'type': 'Computer',
      'category': 'Computer',
      'image': 'https://cdn.thewirecutter.com/wp-content/media/2023/01/gamingmouse-2048px-logitech-g502x-plus-top.jpg',
    },
    {
      'name': 'iPad Air 5',
      'type': 'iPad',
      'category': 'iPad',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'name': 'Canon EOS R10',
      'type': 'Camera',
      'category': 'Camera',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
    },
    {
      'name': 'Office Desk',
      'type': 'Desk',
      'category': 'Desk',
      'image': 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=Office+Desk',
    },
    {
      'name': 'Wireless Keyboard',
      'type': 'Computer',
      'category': 'Computer',
      'image': 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=Keyboard',
    },
    {
      'name': 'iPad Pro 11',
      'type': 'iPad',
      'category': 'iPad',
      'image': 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
    },
    {
      'name': 'Sony A7C',
      'type': 'Camera',
      'category': 'Camera',
      'image': 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/s/o/sony-a7c_1.png',
    },
    {
      'name': 'Standing Desk',
      'type': 'Desk',
      'category': 'Desk',
      'image': 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=Standing+Desk',
    },
  ];

  // Filter assets based on search and category
  List<Map<String, String>> get filteredAssets {
    List<Map<String, String>> filtered = allAssets;
    
    // Apply category filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((asset) => asset['category'] == _selectedFilter).toList();
    }
    
    // Apply search filter
    if (_searchCtrl.text.isNotEmpty) {
      final searchTerm = _searchCtrl.text.toLowerCase();
      filtered = filtered.where((asset) => 
        asset['name']!.toLowerCase().contains(searchTerm) ||
        asset['type']!.toLowerCase().contains(searchTerm)
      ).toList();
    }
    
    return filtered;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
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

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6EAAD7) : const Color(0xFF1B3358),
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label, 
            style: TextStyle(
              fontSize: 14, 
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector to unfocus search when tapping outside
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Drawer (sidebar)
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
                      // filled circular avatar using DecorationImage to ensure the image fully fills the circle
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
                    // Home is current page: just close drawer and optionally scroll to top
                    Navigator.pop(context);
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
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StdHistory(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text('Logout', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // close drawer first, then show confirmation dialog
                    Navigator.pop(context);
                    _confirmLogout(context);
                  },
                ),
              ],
            ),
          ),
        ),

        // AppBar - make transparent so background gradient shows
        appBar: AppBar(
          title: const Text('Asset Borrowing System'),
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
                  const Text('username', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),

        // Body with same gradient as Welcome page (inside SafeArea)
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F161C),
                  Color(0xFF456882),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar with clear suffix
                  TextField(
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
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All'),
                        _buildFilterChip('Computer'),
                        _buildFilterChip('iPad'),
                        _buildFilterChip('Camera'),
                        _buildFilterChip('Desk'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Asset Cards Grid
                  Expanded(
                    child: filteredAssets.isEmpty
                        ? const Center(
                            child: Text(
                              'No assets found',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          )
                        : GridView.builder(
                            itemCount: filteredAssets.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              final asset = filteredAssets[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const StdRequest(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: const Color(0xFF1B3358),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(12)),
                                          child: Image.network(
                                            asset['image']!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                              color: const Color(0xFF283C45),
                                              child: const Center(
                                                child: Icon(Icons.broken_image,
                                                    color: Colors.white30),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(asset['name']!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            const SizedBox(height: 4),
                                            Text(asset['type']!,
                                                style:
                                                    const TextStyle(color: Colors.white70)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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