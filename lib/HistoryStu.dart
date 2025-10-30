import 'package:flutter/material.dart';

class HistoryStu extends StatelessWidget {
  const HistoryStu({super.key});

  @override
  Widget build(BuildContext context) {
    final historyData = {
      '02/10/2025': [
        {
          'item': 'Canon EOS R10',
          'status': 'Approved',
          'approver': 'Ajarn',
          'borrowDate': 'xx/xx/xxxx',
          'returnDate': 'xx/xx/xxxx',
        },
        {
          'item': 'Canon EOS R10',
          'status': 'Rejected',
          'approver': 'Ajarn',
          'borrowDate': 'xx/xx/xxxx',
          'returnDate': 'xx/xx/xxxx',
        },
      ],
      '01/10/2025': [
        {
          'item': 'Canon EOS R10',
          'status': 'Approved',
          'approver': 'Ajarn',
          'borrowDate': 'xx/xx/xxxx',
          'returnDate': 'xx/xx/xxxx',
        },
        {
          'item': 'Canon EOS R10',
          'status': 'Rejected',
          'approver': 'Ajarn',
          'borrowDate': 'xx/xx/xxxx',
          'returnDate': 'xx/xx/xxxx',
        },
        {
          'item': 'Canon EOS R10',
          'status': 'Rejected',
          'approver': 'Ajarn',
          'borrowDate': 'xx/xx/xxxx',
          'returnDate': 'xx/xx/xxxx',
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowing History'),
        backgroundColor: const Color(0xFF15253F),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/1077/1077012.png'),
                  radius: 16,
                ),
                SizedBox(width: 8),
                Text('username', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C192C), Color(0xFF1B3358)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: historyData.entries.map((entry) {
            final date = entry.key;
            final items = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: items.map((item) {
                    final status = item['status'];
                    final isApproved = status == 'Approved';

                    // ✅ ใช้สีสดกว่าของเดิม
                    final bgColor = isApproved
                        ? Colors.greenAccent.shade100
                        : Colors.redAccent.shade100;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          item['item']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isApproved
                                  ? 'Approved by: ${item['approver']}'
                                  : 'Rejected by: ${item['approver']}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            Text(
                              'Borrow date: ${item['borrowDate']}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                            Text(
                              'Return date: ${item['returnDate']}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87),
                            ),
                          ],
                        ),
                        trailing: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://www.canon-europe.com/media/eos%20r10%20front%20slant%20transparant_tcm13-2207374.png',
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.camera_alt, size: 40),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
