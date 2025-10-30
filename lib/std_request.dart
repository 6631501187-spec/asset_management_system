import 'package:flutter/material.dart';

class StdRequest extends StatefulWidget {
  const StdRequest({super.key});

  @override
  State<StdRequest> createState() => _StdRequestState();
}

class _StdRequestState extends State<StdRequest> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _requestDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();

  DateTime? _requestDate;
  DateTime? _returnDate;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {required bool isRequest}) async {
    final DateTime now = DateTime.now();
    final DateTime first = isRequest ? DateTime(now.year, now.month, now.day) : (_requestDate ?? DateTime(now.year, now.month, now.day));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isRequest ? (_requestDate ?? first) : (_returnDate ?? first)),
      firstDate: first,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        final formatted = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
        controller.text = formatted;
        if (isRequest) {
          _requestDate = DateTime(picked.year, picked.month, picked.day);
          // if return date exists but is before new request date, clear it
          if (_returnDate != null && _returnDate!.isBefore(_requestDate!)) {
            _returnDate = null;
            _returnDateController.clear();
          }
        } else {
          _returnDate = DateTime(picked.year, picked.month, picked.day);
        }
      });
    }
  }

  DateTime? _parseControllerDate(String text) {
    try {
      final parts = text.split('/');
      if (parts.length != 3) return null;
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _requestDateController.dispose();
    _returnDateController.dispose();
    super.dispose();
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
             child: Form(
               key: _formKey,
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
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mouse',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Electronics',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Request date
                    TextFormField(
                      controller: _requestDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Request date',
                        hintText: 'mm/dd/yyyy',
                        filled: true,
                        fillColor: const Color(0xFF0C192C),
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today, color: Colors.white70),
                          onPressed: () =>
                              _selectDate(context, _requestDateController, isRequest: true),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a request date';
                        }
                        final parsed = _parseControllerDate(value);
                        if (parsed == null) return 'Invalid date';
                        final today = DateTime.now();
                        final todayDate = DateTime(today.year, today.month, today.day);
                        if (parsed.isBefore(todayDate)) {
                          return 'Request date cannot be in the past';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Return date
                    TextFormField(
                      controller: _returnDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Return date',
                        hintText: 'mm/dd/yyyy',
                        filled: true,
                        fillColor: const Color(0xFF0C192C),
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today, color: Colors.white70),
                          onPressed: () =>
                              _selectDate(context, _returnDateController, isRequest: false),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a return date';
                        }
                        final parsedReturn = _parseControllerDate(value);
                        if (parsedReturn == null) return 'Invalid date';
                        final parsedRequest = _requestDate ?? _parseControllerDate(_requestDateController.text);
                        if (parsedRequest == null) return 'Select request date first';
                        if (parsedReturn.isBefore(parsedRequest)) {
                          return 'Return date cannot be earlier than request date';
                        }
                        return null;
                      },
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
                              // validate form and date logic
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Request submitted successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pop(context);
                                });
                              }
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
      ),
    );
  }
}