import 'package:flutter/material.dart';
import 'std_home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _rePassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureRePass = true;
  String? _errorMsg;

  // Add map to track field errors
  Map<String, String?> _fieldErrors = {
    'name': null,
    'id': null,
    'password': null,
    'rePassword': null,
  };


  @override
  void initState() {
    super.initState();
    // Only keep password match validation
    _passCtrl.addListener(() {
      if (_rePassCtrl.text.isNotEmpty) {
        setState(() {
          _errorMsg = _rePassCtrl.text != _passCtrl.text ? 'Passwords do not match' : null;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _passCtrl.dispose();
    _rePassCtrl.dispose();
    super.dispose();
  }

  void _register() {
    String name = _nameCtrl.text.trim();
    String id = _idCtrl.text.trim();
    String password = _passCtrl.text.trim();
    String rePassword = _rePassCtrl.text.trim();

    if (id == "6631501104" || id == "6631501187" || id == "6631501121") {
      setState(() {
        _errorMsg = "Existing user or password dont match";
      });
    } else if (password != rePassword) {
      setState(() {
        _errorMsg = "Existing user or password dont match";
      });
    } else if (name.isNotEmpty && id.isNotEmpty && password.isNotEmpty) {
      _showSuccessDialog(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StdHome()),
        );
      });
    } else {
      setState(() {
        _errorMsg = "Please fill in all fields";
      });
    }
  }

  void _showSuccessDialog(VoidCallback onComplete) async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false, // Prevent manual dismissal
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 300,
          height: 200,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF456882),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color(0xFF47FF22),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF47FF22),
                size: 40,
              ),
              SizedBox(height: 16),
              Text(
                'Registered',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Successfully!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    // Auto-close after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close the dialog
        onComplete(); // Execute the callback (navigation)
      }
    });
  }

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Color(0xFF20343A),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F161C), Color(0xFF456882)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // center card
              Center(
                child: Container(
                  width: 350,
                  height: 600,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Color(0xFF456882), // solid background
                    border: Border.all(color: Color(0xFF47FF22), width: 2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFE6DDD6),
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 18),
                          // Name
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Name',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                          SizedBox(height: 6),
                          // Name TextField
                          TextField(
                            controller: _nameCtrl,
                            style: TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(hint: 'Your name').copyWith(
                              errorText: _fieldErrors['name'],
                              errorStyle: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Student ID
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Student ID',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                          SizedBox(height: 6),
                          // Student ID TextField
                          TextField(
                            controller: _idCtrl,
                            style: TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(hint: 'Your student ID').copyWith(
                              errorText: _fieldErrors['id'],
                              errorStyle: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                          SizedBox(height: 6),
                          // Password TextField
                          TextField(
                            controller: _passCtrl,
                            obscureText: _obscurePass,
                            style: TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(hint: 'Password').copyWith(
                              errorText: _fieldErrors['password'],
                              errorStyle: TextStyle(color: Colors.redAccent),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white60,
                                ),
                                onPressed: () => setState(() => _obscurePass = !_obscurePass),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Re-enter password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Re-enter password',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                          SizedBox(height: 6),
                          // Re-enter password TextField
                          TextField(
                            controller: _rePassCtrl,
                            obscureText: _obscureRePass,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _errorMsg = value.isNotEmpty && value != _passCtrl.text
                                    ? 'Passwords do not match'
                                    : null;
                              });
                            },
                            decoration: _fieldDecoration(hint: 'Re-enter password').copyWith(
                              errorText: _fieldErrors['rePassword'],
                              errorStyle: TextStyle(color: Colors.redAccent),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureRePass ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white60,
                                ),
                                onPressed: () => setState(() => _obscureRePass = !_obscureRePass),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // error message placed between fields and buttons
                      if (_errorMsg != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            _errorMsg!,
                            style: TextStyle(color: Colors.redAccent, fontSize: 14),
                          ),
                        ),

                      // buttons row (Cancel goes back)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Cancel
                            SizedBox(
                              width: 140,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 141, 53, 53),
                                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                  elevation: 6,
                                  shadowColor: Colors.black45,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text('Cancel'),
                              ),
                            ),
                            // Register: show dialog that dismisses on any tap, then navigate
                            SizedBox(
                              width: 140,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  _register();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6EAAD7),
                                  foregroundColor: Color(0xFF0F161C),
                                  elevation: 6,
                                  shadowColor: Colors.black45,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text('Register'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // keep spacing similar to image
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}