import 'package:flutter/material.dart';

class ReturnStaff extends StatefulWidget {
  const ReturnStaff({super.key});

  @override
  State<ReturnStaff> createState() => _ReturnStaffState();
}

class _ReturnStaffState extends State<ReturnStaff> {
  final TextEditingController assetIdController = TextEditingController();
  final TextEditingController borrowerNameController = TextEditingController();
  DateTime? returnDate;

  Future<void> _pickReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  void _submitForm() {
    if (assetIdController.text.isEmpty ||
        borrowerNameController.text.isEmpty ||
        returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Asset return submitted successfully!'),
        backgroundColor: Color(0xFF38B000),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C192C),
      appBar: AppBar(
  backgroundColor: const Color(0xFF15253F),
  title: const Text(
    'Asset Return',
    style: TextStyle(
      color: Colors.white, // 👈 เปลี่ยนสีข้อความเป็นสีขาว
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white), // ถ้ามีปุ่ม back ให้เป็นสีขาวด้วย
  actions: const [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/1077/1077012.png'),
            radius: 16,
          ),
          SizedBox(width: 8),
          Text(
            'username',
            style: TextStyle(
              color: Colors.white, // 👈 สีชื่อผู้ใช้ก็ขาวเหมือนกัน
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  ],
),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3358),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Process Asset Return',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6EC1E4), // ฟ้าอ่อนสไตล์ภาพต้นฉบับ
                  ),
                ),
                const SizedBox(height: 20),

                // Asset ID
                TextField(
                  controller: assetIdController,
                  decoration: InputDecoration(
                    labelText: 'Asset ID',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF223A5E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Borrower Name
                TextField(
                  controller: borrowerNameController,
                  decoration: InputDecoration(
                    labelText: 'Borrower Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF223A5E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Return Date
                TextField(
                  readOnly: true,
                  onTap: _pickReturnDate,
                  decoration: InputDecoration(
                    labelText: 'Return Date',
                    hintText: returnDate == null
                        ? 'mm/dd/yyyy'
                        : '${returnDate!.month}/${returnDate!.day}/${returnDate!.year}',
                    hintStyle: const TextStyle(color: Colors.white60),
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF223A5E),
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),

                // Submit Button (ฟ้านุ่ม)
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E90FF), // ฟ้าแบบภาพ
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 12),

                // Cancel Button (แดงนุ่ม)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4C4C), // แดงนวล
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
