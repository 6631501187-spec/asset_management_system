import 'package:flutter/material.dart';
import 'services/request_service.dart';
import 'services/user_session.dart';
import 'welcome.dart';

class StdRequest extends StatefulWidget {
  final Map<String, dynamic> asset;
  
  const StdRequest({super.key, required this.asset});

  @override
  State<StdRequest> createState() => _StdRequestState();
}

class _StdRequestState extends State<StdRequest> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  void _checkUserSession() {
    if (!UserSession.isLoggedIn()) {
      // Redirect to login if not logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_isLoading) return;

    final userId = UserSession.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User session expired. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await RequestService.createRequest(widget.asset['asset_id'], userId);
      
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request failed: ${e.toString().replaceAll('Exception: ', '').replaceAll('Failed to create request: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                        widget.asset['image'],
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
                        children: [
                          const Text(
                            'Asset Information',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Asset ID: ${widget.asset['asset_id']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Name: ${widget.asset['name']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Type: ${widget.asset['type']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.asset['description'] ?? 'No description available.',
                            style: const TextStyle(
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
                            onPressed: _isLoading ? null : _submitRequest,
                            child: _isLoading 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Request'),
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