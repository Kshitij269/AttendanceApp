import 'package:attendanceapp/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:attendanceapp/screens/authforms.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final weight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4568DC), Color(0xFFB06AB3)], // Adjust gradient colors
            ),
          ),
          alignment: Alignment.center,
          height: height,
          child: AuthForm(),
        ));
  }
}
