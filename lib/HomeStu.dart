import 'package:flutter/material.dart';
import 'RequestStu.dart';
import 'CheckStatusStu.dart';
import 'HistoryStu.dart';
class HomeStu extends StatelessWidget {
  const HomeStu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Borrowing System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0C192C),
        cardColor: const Color(0xFF15253F),
      ),
      home: const StudentHomePage(),
    );
  }
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer (เมนูด้านข้าง)
      drawer: Drawer(
  child: Container(
    color: const Color(0xFF15253F),
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Color(0xFF1B3358)),
          child: Center(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
        ),
        ListTile(
          leading: const Icon(Icons.history_edu),
          title: const Text('Check Status'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckStatusStu(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.history_toggle_off),
          title: const Text('Borrowing History'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryStu(),
              ),
            );
          },
        ),
        const ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
        ),
      ],
    ),
  ),
),

      // AppBar
      appBar: AppBar(
        title: const Text('Asset Borrowing System'),
        backgroundColor: const Color(0xFF15253F),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/1077/1077012.png',
                  ),
                  radius: 16,
                ),
                SizedBox(width: 8),
                Text('username', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search assets...',
                filled: true,
                fillColor: const Color(0xFF1B3358),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('Computer'),
                _buildFilterChip('Ipad'),
                _buildFilterChip('Camera'),
                _buildFilterChip('Desk'),
              ],
            ),
            const SizedBox(height: 16),

            // Asset Cards Grid
            Expanded(
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              'https://cdn.thewirecutter.com/wp-content/media/2023/01/gamingmouse-2048px-logitech-g502x-plus-top.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mouse',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                'Electronics',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),

                              // ✅ ปุ่ม Request ไปหน้า RequestStu
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RequestStu(), // ✅ หน้า RequestStu
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Request'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  // ฟังก์ชันสร้าง Filter Chip
  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B3358),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
