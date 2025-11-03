import 'package:flutter/material.dart';

class StdRequest extends StatefulWidget {
  const StdRequest({super.key});

  @override
  State<StdRequest> createState() => _StdRequestState();
}

class _StdRequestState extends State<StdRequest> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request to borrow'),
        backgroundColor: const Color(0xFF15253F),
        foregroundColor: Colors.white,
      ),

      // Body uses same gradient as Welcome page (inside SafeArea)
      body: SafeArea(
        child: Container(
         width: double.infinity,
         decoration: const BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Color(0xFF0F161C),
               Color(0xFF456882),
             ],
           ),
         ),
         child: Center(
           child: SingleChildScrollView(
             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
             child: Container(
                 width: 320,
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   // Card color matching the provided image
                   color: const Color(0xFF456882),
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: const Color(0xFF47FF22), width: 2),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.35),
                       blurRadius: 12,
                       offset: const Offset(0, 6),
                     ),
                   ],
                 ),
                 child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        // generic item image
                        'https://via.placeholder.com/300x200.png?text=Item',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          color: const Color(0xFF283C45),
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Asset Information
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C192C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Asset Information',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Asset ID: MSE-001',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Name: Logitech MX Master 3S',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Type: Electronics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Wireless mouse with ergonomic design, suitable for productivity work. Includes USB-C charging cable and unifying receiver.',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buttons - styled to match provided image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B2F2F),
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                              shadowColor: Colors.black45,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6EAAD7),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                              shadowColor: Colors.black45,
                            ),
                            onPressed: () {
                              // Submit the request directly since no validation needed
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Request submitted successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                            },
                            child: const Text('Request'),
                          ),
                        ),
                      ],
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