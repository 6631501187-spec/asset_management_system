import 'package:flutter/material.dart';
import 'constants/app_constants.dart';


class EditAssetPage extends StatefulWidget {
  const EditAssetPage({
    super.key,
    required this.assetId,
    this.initialName = 'Mac Book Air 008',
    this.initialType = 'Laptop',
    this.initialStatus = 'Available',
    this.onConfirm,
    this.onCancel,
  });


  final String assetId;
  final String initialName;
  final String initialType;
  final String initialStatus;


  final void Function(Map<String, String> data)? onConfirm;
  final VoidCallback? onCancel;


  @override
  State<EditAssetPage> createState() => _EditAssetPageState();
}


class _EditAssetPageState extends State<EditAssetPage> {
  final _nameCtrl = TextEditingController();
  late String _type;
  late String _status;


  final _types = const ['Laptop', 'Desktop', 'Phone', 'Tablet', 'Camera', 'Other'];
  final _statuses = const ['Available', 'Disabled'];


  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.initialName;
    _type = widget.initialType;
    // Map "Borrowed" to "Available" if needed
    _status = widget.initialStatus == 'Borrowed' ? 'Available' : widget.initialStatus;
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Only a back arrow (no drawer for this screen)
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2430),
        foregroundColor: Colors.white,
        title: const Text('Edit Asset'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  backgroundImage: NetworkImage(AppConstants.defaultProfileImageUrl),
                ),
                const SizedBox(height: 4),
                const Text('username', style: TextStyle(fontSize: 12, color: Colors.white)),
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
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
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Asset',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6EC1E4),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Image placeholder
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF223A5E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Change image button
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _toast(context, 'Change image tapped');
                        },
                        child: const Text(
                          'Change image',
                          style: TextStyle(
                            color: Color(0xFF6EC1E4),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Asset ID
                    Text(
                      'Asset ID: ${widget.assetId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Name
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                    
                    // Type
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF223A5E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: const Color(0xFF223A5E),
                      style: const TextStyle(color: Colors.white),
                      items: _types
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _type = v!),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    
                    // Status
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: const Color(0xFF223A5E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: const Color(0xFF223A5E),
                      style: const TextStyle(color: Colors.white),
                      items: _statuses
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _status = v!),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    
                    // Confirm Button
                    ElevatedButton(
                      onPressed: () {
                        final data = {
                          'assetId': widget.assetId,
                          'name': _nameCtrl.text.trim(),
                          'type': _type,
                          'status': _status,
                        };
                        widget.onConfirm?.call(data);
                        
                        // Show success dialog
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
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
                                  children: const [
                                    Text(
                                      'Asset updated\nsuccessfully',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFE6DDD6),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        // Auto close dialog after 2 seconds and navigate back
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            Navigator.of(context).pop(); // Close dialog
                            Navigator.of(context).pop(); // Close edit page
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39B54A),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text('Confirm',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    const SizedBox(height: 12),
                    
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        widget.onCancel?.call();
                        Navigator.maybePop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD53D3D),
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
        ),
      ),
    );
  }
}


/* ---------- misc ---------- */


void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}



