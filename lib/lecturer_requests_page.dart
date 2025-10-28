import 'package:flutter/material.dart';
import 'lecturer_dashboard_page.dart'; // เอาไว้ใช้ Drawer เดิม

/// ============================================
/// Lecturer Requests Page (Approve/Disapprove)
/// ============================================
class LecturerRequestsPage extends StatelessWidget {
  const LecturerRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = _sampleRequests;

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
          'View Borrowing Requests',
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
      drawer: const AppDrawer(currentRoute: AppRoutes.requests),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E2430), Color(0xFF143A4A), Color(0xFF1E5B74)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, i) {
            final req = requests[i];
            return _RequestCard(record: req);
          },
        ),
      ),
    );
  }
}

/// ---------------- Card (แต่ละคำขอยืม) ----------------
class _RequestCard extends StatelessWidget {
  final _RequestRecord record;
  const _RequestCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.assetName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  Text('Borrower: ${record.borrower}',
                      style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(
                    'Request: ${record.requestDate}  &  Return: ${record.returnDate}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  const Text('Status: Pending',
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          child: const Text('Disapprove',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          child: const Text('Approve',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // ✅ รูปทรัพย์สิน
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                record.image,
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
          ],
        ),
      ),
    );
  }
}

/// ---------------- Model + Data ----------------
class _RequestRecord {
  final String assetName;
  final String borrower;
  final String requestDate;
  final String returnDate;
  final String image;

  _RequestRecord({
    required this.assetName,
    required this.borrower,
    required this.requestDate,
    required this.returnDate,
    required this.image,
  });
}

/// ✅ ตัวอย่างข้อมูล
final _sampleRequests = <_RequestRecord>[
  _RequestRecord(
    assetName: 'Macbook Air M2',
    borrower: 'User1',
    requestDate: '21/10/25',
    returnDate: '28/10/25',
    image:
        'https://media-cdn.bnn.in.th/442496/TH_MacBook_Air_13-inch_M2_Midnight_-1-square_medium.jpg',
  ),
  _RequestRecord(
    assetName: 'ASUS TUF F15',
    borrower: 'User2',
    requestDate: '21/10/25',
    returnDate: '25/10/25',
    image:
        'https://media-cdn.bnn.in.th/317594/Asus-TUF-Gaming-F15-FX506LH-HN004W-square_medium.jpg',
  ),
  _RequestRecord(
    assetName: 'Canon EOS R10',
    borrower: 'User3',
    requestDate: '21/10/25',
    returnDate: '22/10/25',
    image:
        'https://www.bigcamera.co.th/media/catalog/product/cache/6cfb1b58b487867e47102a5ca923201b/1/6/1653353121_1708097.jpg',
  ),
];