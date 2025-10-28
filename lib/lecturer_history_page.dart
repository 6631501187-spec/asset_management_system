import 'package:flutter/material.dart';

void main() => runApp(const AssetBorrowingApp());

/// -----------------------------
/// App + Routes (ไฟล์เดียวจบ)
/// -----------------------------
class AssetBorrowingApp extends StatelessWidget {
  const AssetBorrowingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Borrowing System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1E5B74)),
      // ใช้ named routes แต่ทุกอย่างอยู่ไฟล์นี้หมด
      initialRoute: AppRoutes.dashboard,
      routes: {
        AppRoutes.dashboard: (_) => const LecturerDashboardPage(),
        AppRoutes.requests : (_) => const LecturerRequestsPage(),
        AppRoutes.history  : (_) => const LecturerHistoryPage(),
        AppRoutes.profile  : (_) => const LecturerProfilePage(),
      },
    );
  }
}

class AppRoutes {
  static const dashboard = '/';
  static const requests  = '/requests';
  static const history   = '/history';
  static const profile   = '/profile';
}

/// -----------------------------
/// Drawer ใช้ร่วมทุกหน้า (ไฟล์เดียว)
/// -----------------------------
class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    ListTile item(IconData icon, String label, String goRoute) {
      final selected = currentRoute == goRoute;
      return ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        selected: selected,
        selectedTileColor: Colors.white12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          Navigator.pop(context); // ปิด drawer
          if (!selected) Navigator.pushReplacementNamed(context, goRoute);
        },
      );
    }

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
            const Divider(color: Colors.white54, thickness: 0.5),
            item(Icons.edit,          'Edit profile',   AppRoutes.profile),
            item(Icons.home_outlined, 'Home',           AppRoutes.dashboard),
            item(Icons.inbox,         'Check requests', AppRoutes.requests),
            item(Icons.history,       'History',        AppRoutes.history),
            const Spacer(),
            const Divider(color: Colors.white54, thickness: 0.5),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {/* TODO: logout */},
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------
/// DASHBOARD (placeholder พอให้ทดสอบ)
/// -----------------------------
class LecturerDashboardPage extends StatelessWidget {
  const LecturerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Lecturer Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
      drawer: const AppDrawer(currentRoute: AppRoutes.dashboard),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
          ),
        ),
        child: const Center(
          child: Text('Dashboard placeholder',
              style: TextStyle(color: Colors.white70)),
        ),
      ),
    );
  }
}

/// -----------------------------
/// HISTORY (ตัวจริงตามสเปก + รูป URL)
//  * ไม่สร้างไฟล์เพิ่ม ทุกอย่างอยู่ในไฟล์นี้
/// -----------------------------
class LecturerHistoryPage extends StatelessWidget {
  const LecturerHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final records = _sampleData;

    // group by date
    final Map<String, List<_HistoryRecord>> grouped = {};
    for (final r in records) {
      grouped.putIfAbsent(r.dateLabel, () => []).add(r);
    }
    final dates = grouped.keys.toList();

    return Scaffold(
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
          'Lecturer History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
      drawer: const AppDrawer(currentRoute: AppRoutes.history),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dates.length,
          itemBuilder: (context, i) {
            final date = dates[i];
            final items = grouped[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateHeader(date),
                const SizedBox(height: 8),
                ...items.map((r) => _HistoryCard(record: r)),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ใช้ฟังก์ชันแทนการสร้าง class แยก (หลบ error ที่คุณเจอ)
  Widget _dateHeader(String text) {
    return Container(
      height: 32,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E4756),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final _HistoryRecord record;
  const _HistoryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        record.status == _HistoryStatus.approved ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.assetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('Borrower: ${record.borrower}',
                      style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 6),
                  _StatusBadge(
                    label: record.status == _HistoryStatus.approved
                        ? 'Approved'
                        : 'Disapproved',
                    color: statusColor,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Request: ${record.requestDate}  &  Return: ${record.returnDate}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // image (URL + loader + error safe)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                record.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                (progress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  width: 60, height: 60,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.black45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

/// -----------------------------
/// Requests + Profile (placeholder ให้เมนูทำงาน)
/// -----------------------------
class LecturerRequestsPage extends StatelessWidget {
  const LecturerRequestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2430),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Borrow Requests',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.requests),
      body: const Center(child: Text('Requests placeholder', style: TextStyle(color: Colors.white70))),
    );
  }
}

class LecturerProfilePage extends StatelessWidget {
  const LecturerProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2430),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Edit Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.profile),
      body: const Center(child: Text('Profile placeholder', style: TextStyle(color: Colors.white70))),
    );
  }
}

/// -----------------------------
/// Model & Demo data (มี image URL)
/// -----------------------------
enum _HistoryStatus { approved, disapproved }

class _HistoryRecord {
  final String dateLabel;
  final String assetName;
  final String borrower;
  final String requestDate;
  final String returnDate;
  final _HistoryStatus status;
  final String image;

  _HistoryRecord({
    required this.dateLabel,
    required this.assetName,
    required this.borrower,
    required this.requestDate,
    required this.returnDate,
    required this.status,
    required this.image,
  });
}

final _sampleData = <_HistoryRecord>[
  _HistoryRecord(
    dateLabel: '01/10/2025',
    assetName: 'Canon EOS R10',
    borrower: 'User1',
    requestDate: '21/10/25',
    returnDate: '28/10/25',
    status: _HistoryStatus.approved,
    image:
        'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
  ),
  _HistoryRecord(
    dateLabel: '01/10/2025',
    assetName: 'Sony A7C',
    borrower: 'User2',
    requestDate: '21/10/25',
    returnDate: '25/10/25',
    status: _HistoryStatus.disapproved,
    image:
        'https://www.bigcamera.co.th/media/catalog/product/cache/69a3da6bcd95df779892f4b24fa6a6f7/s/o/sony-a7c_1.png',
  ),
  _HistoryRecord(
    dateLabel: '01/10/2025',
    assetName: 'iPad Air 5',
    borrower: 'User1',
    requestDate: '21/10/25',
    returnDate: '28/10/25',
    status: _HistoryStatus.approved,
    image:
        'https://static-jaymart.com/ecom/public/2mdZjASmEDHyucCtzlOhlsIDjrj.jpg',
  ),
  _HistoryRecord(
    dateLabel: '01/10/2025',
    assetName: 'ASUS TUF F15',
    borrower: 'User1',
    requestDate: '21/10/25',
    returnDate: '22/10/25',
    status: _HistoryStatus.approved,
    image:
        'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
  ),
];