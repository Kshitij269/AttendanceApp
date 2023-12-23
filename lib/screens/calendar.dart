import 'package:attendanceapp/widgets/constants.dart';
import 'package:attendanceapp/widgets/datetime.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width:width,
      height: height,

      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[900], // Set background color to a dark shade
                borderRadius: BorderRadius.circular(15),
              ),
              child: DateTimeContainer()
            ),
          )
          ,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal:10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // Set background color to a dark shade
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(child: Calendar()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableCalendar<dynamic> Calendar() {
    return TableCalendar(
            calendarFormat: CalendarFormat.month, // Set calendar format to month view
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(color: kwhite,fontSize: 20),
              leftChevronIcon : const Icon(Icons.chevron_left,color: kwhite,),
              rightChevronIcon : const Icon(Icons.chevron_right,color: kwhite,),
              titleCentered: true,

            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.red),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
              holidayTextStyle: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
              outsideTextStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              disabledTextStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              rangeStartTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              rangeEndTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              weekNumberTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              cellMargin: EdgeInsets.all(2),
            ),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2050, 3, 14),
          );
  }
}
