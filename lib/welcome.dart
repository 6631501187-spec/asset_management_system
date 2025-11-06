import 'package:flutter/material.dart';
import 'Login.dart';
import 'Register.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F161C),
                Color(0xFF456882),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Asset Borrowing System',
                style: TextStyle(
                  color: Color(0xFFE6DDD6),
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Container(
                  width: 350,
                  height: 450,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF456882), // Changed from gradient to solid color
                    border: Border.all(
                      color: Color(0xFF47FF22),
                      width: 2,
                    ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 18, left: 8, right: 8),
                        child: Text(
                          'Securely borrow essential devices and tech accessories required for modern coursework and cutting-edge student projects.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 20,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 180,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  // changed to push so Login keeps history like Register
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => Login()),
                                  );
                                },
                                child: Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6EAAD7),
                                  foregroundColor: const Color.fromRGBO(15, 22, 28, 1),
                                  elevation: 8,
                                  shadowColor: Color.fromRGBO(15, 22, 28, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: 180,
                              height: 44,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => Register()),
                                    );
                                  },
                                  child: Text('Register'),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xFF47FF22), width: 1),
                                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}