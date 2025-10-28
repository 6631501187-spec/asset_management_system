import 'package:flutter/material.dart';

/// =====================================================
/// Staff Dashboard (UI only, no navigation)
/// =====================================================
class StaffDashboardPage extends StatelessWidget {
  const StaffDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _StaffDrawer(), // Sidebar แบบในภาพ
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
        title: const Row(
          children: [
            Icon(Icons.badge, color: Colors.white70, size: 20),
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
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _SearchField(),
            SizedBox(height: 12),
            _FilterTabs(),
            SizedBox(height: 12),
            _KpiRow(),
            SizedBox(height: 20),
            _SectionTitle('Today'),
            SizedBox(height: 8),

            // รายการตัวอย่างตามภาพ + ปุ่ม Edit ด้านขวา
            _StaffAssetCard(
              name: 'Canon EOS R10',
              type: 'Camera',
              status: 'Available',
              image:
                  'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
            ),
            _StaffAssetCard(
              name: 'Sony A7C',
              type: 'Camera',
              status: 'Borrowed',
              image:
                  'https://www.bigcamera.co.th/media/catalog/product/cache/69a3da6bcd95df779892f4b24fa6a6f7/s/o/sony-a7c_1.png',
            ),
            _StaffAssetCard(
              name: 'iPad Air 5',
              type: 'Tablet',
              status: 'Disabled',
              image:
                  'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
            ),
            _StaffAssetCard(
              name: 'ASUS TUF F15',
              type: 'Laptop',
              status: 'Available',
              image:
                  'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

/* ========================= Sidebar (Staff) ========================= */
class _StaffDrawer extends StatelessWidget {
  const _StaffDrawer();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label) => ListTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(label, style: const TextStyle(color: Colors.black87)),
          onTap: () {
            // UI only — no navigation
            Navigator.pop(context);
          },
        );

    return Drawer(
      backgroundColor: const Color(0xFF607D8B),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 8),
            const Text('Username',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Container(
              color: Colors.white.withOpacity(0.12),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: const Text('Menu', style: TextStyle(color: Colors.white70)),
            ),
            // เมนูตามภาพ: Edit profile, Home, Add new asset, Asset return, History, Logout
            item(Icons.edit, 'Edit profile'),
            item(Icons.home_outlined, 'Home'),
            item(Icons.add_box_outlined, 'Add new asset'),
            item(Icons.assignment_return_outlined, 'Asset return'),
            item(Icons.history, 'History'),
            const Spacer(),
            const Divider(color: Colors.white54, thickness: 0.5),
            item(Icons.logout, 'Logout'),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/* ========================= Widgets: Top Controls ========================= */
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B38),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search assets…',
          hintStyle: TextStyle(color: Colors.white54),
          icon: Icon(Icons.search, color: Colors.white),
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, Color bg, [Color? text]) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: text ?? Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        );

    return Row(
      children: [
        chip('Available', const Color(0xFF2ECC71).withOpacity(0.25), const Color(0xFF2ECC71)),
        const SizedBox(width: 8),
        chip('Borrowed', const Color(0xFFF5B041).withOpacity(0.35), const Color(0xFFF39C12)),
        const SizedBox(width: 8),
        chip('Disabled', Colors.white.withOpacity(0.6), Colors.black54),
        const SizedBox(width: 8),
        chip('All Assets', const Color(0xFF1565C0).withOpacity(0.9), Colors.white),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _KpiCard(icon: Icons.check_circle, color: Colors.green, label: 'Available', count: 8)),
        SizedBox(width: 8),
        Expanded(child: _KpiCard(icon: Icons.access_time, color: Colors.orange, label: 'Borrowed', count: 8)),
        SizedBox(width: 8),
        Expanded(child: _KpiCard(icon: Icons.remove_circle, color: Colors.grey, label: 'Disabled', count: 2)),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int count;
  const _KpiCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              Text('$count', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

/* ========================= Asset Card (มีปุ่ม Edit) ========================= */
class _StaffAssetCard extends StatelessWidget {
  final String name;
  final String type;
  final String status;
  final String image;

  const _StaffAssetCard({
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
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ข้อมูลซ้าย
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('Type: $type', style: const TextStyle(color: Colors.black54)),
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(color: Colors.black54)),
                      Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // รูป
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.black45),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // ปุ่ม Edit ด้านขวา (สไตล์ pill)
            _EditButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _EditButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A2B38),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text('Edit'),
      ),
    );
  }
}