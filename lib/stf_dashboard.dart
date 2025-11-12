import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'stf_add.dart';
import 'stf_return.dart';
import 'stf_history.dart';
import 'stf_edit.dart';
import 'edit_profile.dart';
import 'welcome.dart';
import 'services/user_session.dart';
import 'services/asset_service.dart';

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
  String _searchQuery = ''; // Track search query
  String _selectedFilter = 'All'; // Track selected filter (type), 'All' or empty means show all types
  String? _currentUsername;
  String? _currentProfileImage;
  List<Map<String, dynamic>> allAssets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadAssets();
  }

  void _loadUserInfo() {
    setState(() {
      _currentUsername = UserSession.getCurrentUsername();
      _currentProfileImage = UserSession.getCurrentProfileImage();
    });
  }

  Future<void> _loadAssets() async {
    try {
      final assets = await AssetService.getAllAssets();
      setState(() {
        allAssets = assets.map((asset) => {
          'asset_id': asset['asset_id'].toString(),
          'name': asset['asset_name'] ?? 'Unknown',
          'type': asset['asset_type'] ?? 'Unknown',
          'status': asset['status'] ?? 'Unknown',
          'description': asset['description'] ?? '',
          'image': asset['image_src'] ?? 'https://via.placeholder.com/300x200/1B3358/FFFFFF?text=No+Image',
        }).toList().cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load assets: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Map<String, dynamic>> get filteredAssets {
    List<Map<String, dynamic>> filtered = allAssets;
    
    // Apply status filter
    if (selectedStatus != null) {
      filtered = filtered.where((asset) => asset['status'] == selectedStatus).toList();
    }
    
    // Apply type filter (only if a specific type is selected, not 'All' or empty)
    if (_selectedFilter.isNotEmpty && _selectedFilter != 'All') {
      filtered = filtered.where((asset) => asset['type'] == _selectedFilter).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final searchTerm = _searchQuery.toLowerCase();
      filtered = filtered.where((asset) => 
        asset['name']!.toString().toLowerCase().contains(searchTerm) ||
        asset['type']!.toString().toLowerCase().contains(searchTerm) ||
        asset['asset_id']!.toString().toLowerCase().contains(searchTerm)
      ).toList();
    }
    
    return filtered;
  }

  int get totalCount => allAssets.length;
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
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_box, color: Colors.white),
                  title: const Text('Add new asset', style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddAssetPage()),
                    );
                    // Reload assets after returning from add page
                    _loadAssets();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_return, color: Colors.white),
                  title: const Text('Asset return', style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReturnStaff()),
                    );
                    // Reload assets after returning from return page
                    _loadAssets();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.white),
                  title: const Text('History', style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryStaff()),
                    );
                    // Reload assets after returning from history page
                    _loadAssets();
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
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Column(
                  children: [
                    // Fixed top section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _StaffSearchBar(onSearchChanged: _onSearchChanged),
                          const SizedBox(height: 12),
                          _StaffFilterChips(
                            selectedFilter: _selectedFilter,
                            onFilterChanged: (filter) {
                              setState(() {
                                // If "All" is clicked, clear filter
                                if (filter == 'All') {
                                  _selectedFilter = '';
                                } else {
                                  // Toggle filter: if same filter clicked, unselect it
                                  _selectedFilter = _selectedFilter == filter ? '' : filter;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _KpiRow(
                            totalCount: totalCount,
                            availableCount: availableCount,
                            borrowedCount: borrowedCount,
                            disabledCount: disabledCount,
                            selectedStatus: selectedStatus,
                            onStatusTap: (status) {
                              setState(() {
                                // Toggle filter: if same status clicked, clear filter (null)
                                // "All" button sets selectedStatus to null
                                if (status == 'All') {
                                  selectedStatus = null;
                                } else {
                                  selectedStatus = selectedStatus == status ? null : status;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: _SectionTitle('Asset List'),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    // Scrollable cards section
                    Expanded(
                      child: filteredAssets.isEmpty
                          ? const Center(
                              child: Text(
                                'No assets found',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredAssets.length,
                              itemBuilder: (context, index) {
                                final asset = filteredAssets[index];
                                return _StaffAssetCard(
                                  assetId: asset['asset_id']!.toString(),
                                  name: asset['name']!.toString(),
                                  type: asset['type']!.toString(),
                                  status: asset['status']!.toString(),
                                  image: asset['image']!.toString(),
                                  onUpdate: _loadAssets,
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
  final int totalCount;
  final int availableCount;
  final int borrowedCount;
  final int disabledCount;
  final String? selectedStatus;
  final Function(String) onStatusTap;

  const _KpiRow({
    required this.totalCount,
    required this.availableCount,
    required this.borrowedCount,
    required this.disabledCount,
    required this.selectedStatus,
    required this.onStatusTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _KpiButton(
              title: 'All',
              count: totalCount,
              color: Colors.blue,
              isSelected: selectedStatus == null,
              onTap: () => onStatusTap('All'),
            ),
            _KpiButton(
              title: 'Available',
              count: availableCount,
              color: Colors.green,
              isSelected: selectedStatus == 'Available',
              onTap: () => onStatusTap('Available'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      title == 'All'
                          ? Icons.apps
                          : title == 'Available'
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
  final VoidCallback? onUpdate;

  const _StaffAssetCard({
    required this.assetId,
    required this.name,
    required this.type,
    required this.status,
    required this.image,
    this.onUpdate,
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
              onPressed: () async {
                await Navigator.push(
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
                // Reload assets after returning from edit page
                onUpdate?.call();
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
  final Function(String) onSearchChanged;
  
  const _StaffSearchBar({required this.onSearchChanged});
  
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
                  widget.onSearchChanged('');
                },
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {});
        widget.onSearchChanged(value);
      },
    );
  }
}

// New: std_home-style filter chips for staff
class _StaffFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  
  const _StaffFilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () => onFilterChanged(label),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Laptop'),
          _buildFilterChip('Mouse'),
          _buildFilterChip('Keyboard'),
          _buildFilterChip('Monitor'),
          _buildFilterChip('Camera'),
          _buildFilterChip('Tablet'),
          _buildFilterChip('Projector'),
          _buildFilterChip('Adapter'),
          _buildFilterChip('Storage'),
          _buildFilterChip('Headphones'),
          _buildFilterChip('Webcam'),
        ],
      ),
    );
  }
}