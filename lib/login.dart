import 'stf_dashboard.dart';
import 'lec_dashboard.dart';
import 'std_home.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'services/auth_service.dart';
import 'services/user_session.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _remember = false;
  bool _isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String userId = _userCtrl.text.trim();
    String password = _passCtrl.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Please enter both ID and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await AuthService.login(userId, password);
      
      setState(() {
        _isLoading = false;
      });

      // Store user session
      UserSession.setCurrentUser(response['user'], response['token']);

      // Navigate based on user role
      final userRole = response['user']['role'].toString().toLowerCase();
      Widget destination;
      
      switch (userRole) {
        case 'student':
          destination = const StdHome();
          break;
        case 'lecturer':
          destination = const LecDashboard();
          break;
        case 'staff':
          destination = const StaffDashboardPage();
          break;
        default:
          destination = const StdHome();
      }

      _showSuccessDialog(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      });
      
    } catch (e) {
      print('Login error: $e'); // Debug print
      setState(() {
        _isLoading = false;
        String message = e.toString();
        
        // Clean up the error message
        message = message.replaceAll('Exception: ', '');
        message = message.replaceAll('Login failed: ', '');
        message = message.replaceAll('Network error: ', '');
        
        // Handle specific errors
        if (message.contains('Connection refused') || message.contains('Failed to connect')) {
          message = 'Unable to connect to server. Please check your connection.';
        } else if (message.contains('Invalid credentials')) {
          message = 'Invalid user ID or password';
        } else if (message.contains('timeout')) {
          message = 'Connection timeout. Please try again.';
        }
        
        errorMessage = message.isEmpty ? 'Login failed. Please try again.' : message;
      });
    }
  }

  void _showSuccessDialog(VoidCallback onOK) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E4057),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color.fromARGB(255, 141, 252, 89),
            width: 2,
          ),
        ),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.lightGreenAccent, size: 60),
            SizedBox(height: 10),
            Text(
              'Login Successful!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pop(context);
      onOK();
    });
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
                  height: 460,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Color(0xFF456882),
                    border: Border.all(color: Color(0xFF47FF22), width: 1),
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
                    children: [
                      SizedBox(height: 6),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFFE6DDD6),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 18),
                      // User ID
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ID',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      TextField(
                        controller: _userCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your user ID',
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
                        ),
                        onChanged: (_) {
                          if (errorMessage.isNotEmpty) {
                            setState(() {
                              errorMessage = '';
                            });
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      // Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.white60),
                          filled: true,
                          fillColor: Color(0xFF20343A),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white60,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                        ),
                        onChanged: (_) {
                          if (errorMessage.isNotEmpty) {
                            setState(() {
                              errorMessage = '';
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      // Error message
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      // remember me
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            activeColor: Colors.white,
                            checkColor: Color(0xFF0F161C),
                            side: BorderSide(color: Colors.white),
                            onChanged: (v) => setState(() => _remember = v ?? false),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'remember me',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Login button
                      Center(
                        child: SizedBox(
                          width: 180,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6EAAD7),
                              foregroundColor: Color(0xFF0F161C),
                              elevation: 8,
                              shadowColor: Colors.black45,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(color: Color(0xFF47FF22), width: 1),
                            ),
                            child: _isLoading 
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0F161C),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text('Login'),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 80,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do not have an account?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => Register()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Color(0xFFE6DDD6)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}