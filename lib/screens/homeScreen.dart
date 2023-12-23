import 'package:attendanceapp/screens/attendance.dart';
import 'package:attendanceapp/screens/calendar.dart';
import 'package:attendanceapp/screens/side.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  int myIndex = 1;
  List<Widget> widgetList = [Attendance(), Calendar(), Timetable()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: kwhite,
          onPressed: () {
            _signOut();
            Fluttertoast.showToast(msg: "Sign Out");
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: kdark,
      ),
      body: Container(
        child: widgetList[myIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        unselectedItemColor: kwhite,
        backgroundColor: kdark,
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Attendance",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "TimeTable"),
        ],
      ),
    );
  }
}
