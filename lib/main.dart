import 'package:flutter/material.dart';
import 'package:asset_management_system/lecturer_dashboard_page.dart';

void main() => runApp(const AssetBorrowingApp());

class AssetBorrowingApp extends StatelessWidget {
  const AssetBorrowingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset Borrowing System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F51B5),
      ),
      home: const LecturerDashboardPage(), // ← ชี้ไปหน้า dashboard
    );
  }
}