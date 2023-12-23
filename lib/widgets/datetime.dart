import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeContainer extends StatefulWidget {
  @override
  _DateTimeContainerState createState() => _DateTimeContainerState();
}

class _DateTimeContainerState extends State<DateTimeContainer> {
  late String formattedDate;
  late String formattedDate1;

  late String formattedTime;

  @override
  void initState() {
    super.initState();

    // Initialize the formatted date and time
    updateDateTime();

    // Set up a periodic timer to update the time every second
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        updateDateTime();
      }
    });
  }

  void updateDateTime() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat.EEEE().format(now);
    formattedDate1 = DateFormat.yMMMd().format(now);

    formattedTime = DateFormat('h:mm:ss a').format(now);

    // Force a rebuild to update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today is',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${formattedDate} - ${formattedDate1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Current Time',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
