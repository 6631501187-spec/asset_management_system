import 'package:flutter/material.dart';

class RequestStu extends StatefulWidget {
  const RequestStu({super.key});

  @override
  State<RequestStu> createState() => _RequestStuState();
}

class _RequestStuState extends State<RequestStu> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _requestDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request to borrow'),
        backgroundColor: const Color(0xFF15253F),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3358),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://cdn.thewirecutter.com/wp-content/media/2023/01/gamingmouse-2048px-logitech-g502x-plus-top.jpg',
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mouse',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Electronics',
                      style: TextStyle(color: Colors.grey),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _requestDateController),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a request date';
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () =>
                              _selectDate(context, _returnDateController),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a return date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Request submitted successfully!'),
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
