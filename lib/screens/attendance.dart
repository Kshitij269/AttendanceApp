import 'package:attendanceapp/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  String uid = '';

  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    setState(() {
      uid = user!.uid;
      print(user!);
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _showAddDataDialog(BuildContext context) async {
    final TextEditingController _subjectController = TextEditingController();
    final TextEditingController _attendedclassController =
        TextEditingController();
    final TextEditingController _totalclassController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add Subject'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                ),
                TextField(
                  controller: _attendedclassController,
                  decoration: InputDecoration(labelText: 'Attended Classes'),
                ),
                TextField(
                  controller: _totalclassController,
                  decoration: InputDecoration(labelText: 'Total Classes'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _addDataToFirestore(
                    _attendedclassController.text,
                    _totalclassController.text,
                    _subjectController.text,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addDataToFirestore(
    String attendedclassController,
    String totalclassController,
    String subject,
  ) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;

    _firestore
        .collection('attendance')
        .doc(uid)
        .collection('subjects')
        .doc(subject)
        .set({
      'subject': subject,
      'attendedclassController': attendedclassController,
      'totalclassController': totalclassController,
    }).then((value) {
      print('Data added to Firestore!');
    }).catchError((error) {
      print('Error adding data to Firestore: $error');
    });
  }

  void _updateDataInFirestore(
    String attendedclassController,
    String totalclassController,
    String subject,
  ) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;

    _firestore
        .collection('attendance')
        .doc(uid)
        .collection('subjects')
        .doc(subject)
        .update({
      'subject': subject,
      'attendedclassController': attendedclassController,
      'totalclassController': totalclassController,
    }).then((value) {
      print('Data updated in Firestore!');
    }).catchError((error) {
      print('Error updating data in Firestore: $error');
    });
  }

  void _deleteDataFromFirestore(
    String subject,
  ) {
    _firestore
        .collection('attendance')
        .doc(uid)
        .collection('subjects')
        .doc(subject)
        .delete()
        .then((value) {
      print('Document deleted from Firestore!');
    }).catchError((error) {
      print('Error deleting document from Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: width,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kdark),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  _showAddDataDialog(context);
                },
                child: Text(
                  'Add Subject',
                  style: TextStyle(color: kwhite, fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('attendance')
                  .doc(uid)
                  .collection('subjects')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Map<String, dynamic>> data = snapshot.data!.docs
                    .map((DocumentSnapshot document) =>
                        document.data() as Map<String, dynamic>)
                    .toList();

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> attendanceData = data[index];

                    double attended =
                        double.parse(attendanceData['attendedclassController']);
                    double total =
                        double.parse(attendanceData['totalclassController']);
                    double percentage = (attended / total) * 100;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Card(
                        color: kdark,
                        elevation: 1,
                        child: Container(
                          height: height * 0.15,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      attendanceData['subject'] ?? 'No Subject',
                                      style: TextStyle(
                                        color: kwhite,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Attendance: ${attendanceData['attendedclassController']} / ${attendanceData['totalclassController']}',
                                      style: TextStyle(
                                        color: kwhite,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      ((int.parse(attendanceData['attendedclassController']) /int.parse(attendanceData['totalclassController']) *100) < 75)
                                          ? 'Low Attendance: ${(int.parse(attendanceData['attendedclassController']) /int.parse(attendanceData['totalclassController']) *100).toStringAsFixed(2)}%'
                                          : 'Your Attendance right',
                                      style: TextStyle(
                                        color: kwhite,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: CircularProgressIndicator(
                                          value: percentage / 100,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.green,
                                          ),
                                          strokeWidth: 10,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '${percentage.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            color: kwhite,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        _showUpdateDialog(
                                          context,
                                          attendanceData['subject'],
                                          attendanceData[
                                              'attendedclassController'],
                                          attendanceData[
                                              'totalclassController'],
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteDataFromFirestore(
                                            attendanceData['subject']);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showUpdateDialog(
    BuildContext context,
    String subject,
    String attended,
    String total,
  ) async {
    final TextEditingController _subjectController =
        TextEditingController(text: subject);
    final TextEditingController _attendedclassController =
        TextEditingController(text: attended);
    final TextEditingController _totalclassController =
        TextEditingController(text: total);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Update Subject'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  readOnly: true,
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                ),
                TextField(
                  controller: _attendedclassController,
                  decoration: InputDecoration(labelText: 'Attended Classes'),
                ),
                TextField(
                  controller: _totalclassController,
                  decoration: InputDecoration(labelText: 'Total Classes'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _updateDataInFirestore(
                    _attendedclassController.text,
                    _totalclassController.text,
                    _subjectController.text,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
