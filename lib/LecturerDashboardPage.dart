import 'package:flutter/material.dart';

class LecturerDashboardPage extends StatelessWidget {
  const LecturerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _LecturerDrawer(), // ✅ Sidebar
      backgroundColor: const Color(0xFF0E2430),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Lecturer Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF1E5B74),
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
                SizedBox(width: 6),
                Text('username', style: TextStyle(color: Colors.white)),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _SearchBar(),
            SizedBox(height: 12),
            _KpiRow(),
            SizedBox(height: 20),
            Text(
              'Today',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _AssetCard(
              name: 'Canon EOS R10',
              type: 'Camera',
              status: 'Available',
              image: 'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
            ),
            _AssetCard(
              name: 'Sony A7C',
              type: 'Camera',
              status: 'Borrowed',
              image: 'https://www.bigcamera.co.th/media/catalog/product/cache/69a3da6bcd95df779892f4b24fa6a6f7/s/o/sony-a7c_1.png',
            ),
            _AssetCard(
              name: 'iPad Air 5',
              type: 'Tablet',
              status: 'Disabled',
              image: 'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
            ),
            _AssetCard(
              name: 'ASUS TUF F15',
              type: 'Laptop',
              status: 'Available',
              image: 'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg'
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Sidebar ---------------- */
class _LecturerDrawer extends StatelessWidget {
  const _LecturerDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF607D8B),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 8),
            const Text('Username', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Divider(color: Colors.white54, thickness: 0.5),
            _drawerItem(Icons.edit, 'Edit profile', onTap: () {}),
            _drawerItem(Icons.home_outlined, 'Home', onTap: () {
              Navigator.pop(context);
            }),
            _drawerItem(Icons.inbox, 'Check requests', onTap: () {}),
            _drawerItem(Icons.history, 'History', onTap: () {}),
            const Spacer(),
            const Divider(color: Colors.white54, thickness: 0.5),
            _drawerItem(Icons.logout, 'Logout', onTap: () {}),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: onTap,
    );
  }
}

/* ---------------- Search Bar ---------------- */
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B38),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Hinted search text',
          hintStyle: TextStyle(color: Colors.white54),
          icon: Icon(Icons.search, color: Colors.white),
        ),
      ),
    );
  }
}

/* ---------------- KPI Row ---------------- */
class _KpiRow extends StatelessWidget {
  const _KpiRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _KpiCard(title: 'Available', count: 8, color: Colors.green)),
        SizedBox(width: 8),
        Expanded(child: _KpiCard(title: 'Borrowed', count: 8, color: Colors.orange)),
        SizedBox(width: 8),
        Expanded(child: _KpiCard(title: 'Disabled', count: 2, color: Colors.grey)),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  const _KpiCard({required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // ลด padding
        child: FittedBox( // ✅ บีบให้พอดีพื้นที่
          fit: BoxFit.scaleDown,
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
                size: 18, // ลดขนาด
              ),
              const SizedBox(width: 6),
              Text(title,
                  style:
                      TextStyle(color: color, fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              Text('$count',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- Asset Card ---------------- */
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
              child: Image.network(image, width: 60, height: 60, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}