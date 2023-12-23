import 'package:attendanceapp/screens/authGate.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4568DC), Color(0xFFB06AB3)], // Adjust gradient colors
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: height*0.2,),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In to',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'Roboto',
                      fontSize: 45,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Attendance',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'Roboto',
                      fontSize: 45,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Management',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'Roboto',
                      fontSize: 45,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'System',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontFamily: 'Roboto',
                      fontSize: 45,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical:20),
                width: width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthGate()),
                    );
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color(0xFF4568DC), // Adjust text color
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
