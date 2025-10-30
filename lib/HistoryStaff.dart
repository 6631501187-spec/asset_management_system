import 'package:flutter/material.dart';

class HistoryStaff extends StatefulWidget {
  const HistoryStaff({super.key});

  @override
  State<HistoryStaff> createState() => _HistoryStaffState();
}

class _HistoryStaffState extends State<HistoryStaff> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> historyData = [
    {
      "date": "01/10/2025",
      "status": "Approved",
      "borrower": "Lone",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "xx/xx/xxxx",
      "returnDate": "xx/xx/xxxx",
      "image":
          "https://cdn.thewirecutter.com/wp-content/media/2023/01/camera-2048px-canon-eosr10-top.jpg"
    },
    {
      "date": "01/10/2025",
      "status": "Disapproved",
      "borrower": "Lone",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "xx/xx/xxxx",
      "returnDate": "xx/xx/xxxx",
      "image":
          "https://cdn.thewirecutter.com/wp-content/media/2023/01/camera-2048px-canon-eosr10-top.jpg"
    },
    {
      "date": "02/10/2025",
      "status": "Approved",
      "borrower": "Lone",
      "approvedBy": "Ajarn",
      "receivedBy": "Staff",
      "borrowDate": "xx/xx/xxxx",
      "returnDate": "xx/xx/xxxx",
      "image":
          "https://cdn.thewirecutter.com/wp-content/media/2023/01/camera-2048px-canon-eosr10-top.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🔍 กรองข้อมูลตามสถานะที่เลือก
    List<Map<String, dynamic>> filteredData = selectedFilter == 'All'
        ? historyData
        : historyData
            .where((item) => item['status'] == selectedFilter)
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0C192C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C192C),
        elevation: 4,
        title: const Text(
          'Staff History',
          style: TextStyle(
            color: Colors.white, // ✅ ตัวอักษรบน AppBar เป็นสีขาว
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // ✅ ไอคอน (เช่นเมนู) สีขาว
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/1077/1077063.png'),
                  radius: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'username',
                  style: TextStyle(
                    color: Colors.white, // ✅ username สีขาว
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),

      // 🧩 เนื้อหาในหน้า
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔘 Filter Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('All', Colors.blue),
                const SizedBox(width: 10),
                _buildFilterChip('Approved', Colors.green),
                const SizedBox(width: 10),
                _buildFilterChip('Disapproved', Colors.red),
              ],
            ),
            const SizedBox(height: 20),

            // 📋 รายการ History
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  final bgColor = item['status'] == 'Approved'
                      ? Colors.green[300] // ✅ สีสดขึ้น
                      : item['status'] == 'Disapproved'
                          ? Colors.red[300]
                          : Colors.grey[200];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: const Text(
                          'Canon EOS R10',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Borrowed by: ${item['borrower']}\n'
                            '${item['status'] == 'Approved' ? 'Approved' : 'Disapproved'} by: ${item['approvedBy']}\n'
                            'Received by: ${item['receivedBy']}\n'
                            'Borrow date: ${item['borrowDate']}\n'
                            'Return date: ${item['returnDate']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
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

  // 🟦 สร้างปุ่มกรองสถานะ
  Widget _buildFilterChip(String label, Color color) {
    final bool isSelected = selectedFilter == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF1B3358),
      onSelected: (_) {
        setState(() {
          selectedFilter = label;
        });
      },
    );
  }
}
