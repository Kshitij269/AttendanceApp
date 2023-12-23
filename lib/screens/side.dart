import 'package:attendanceapp/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
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

  List<String> items = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
 
  void _deleteDataFromFirestore(String uid, String documentId) {
    _firestore
        .collection('schedule')
        .doc(uid)
        .collection(selectedDay)
        .doc(documentId)
        .delete()
        .then((value) {
      print('Document deleted from Firestore!');
    }).catchError((error) {
      print('Error deleting document from Firestore: $error');
    });
  }

  Future<void> _showAddDataDialog(BuildContext context) async {
    final TextEditingController _starttimeController = TextEditingController();
    final TextEditingController _endtimeController = TextEditingController();

    final TextEditingController _subjectController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add Time and Subject for $selectedDay'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _starttimeController,
                  decoration: InputDecoration(labelText: 'Start-Time'),
                ),
                TextField(
                  controller: _endtimeController,
                  decoration: InputDecoration(labelText: 'End-Time'),
                ),
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  _addDataToFirestore(selectedDay, _starttimeController.text,
                      _endtimeController.text, _subjectController.text);
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
      String day, String starttime, String endtime, String subject) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;
    print(selectedDay);

    _firestore.collection('schedule').doc(uid).collection(selectedDay).add({
      'day': day,
      'starttime': starttime,
      'endtime': endtime,
      'subject': subject,
    }).then((value) {
      print('Data added to Firestore!');
    }).catchError((error) {
      print('Error adding data to Firestore: $error');
    });
  }

  String selectedDay = 'Monday';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: width,
                height: 60,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: ((context, index) {
                      return Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = items[index];
                              
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kdark,
                            ),
                            child: Center(
                                child: Text(
                              items[index],
                              style: const TextStyle(
                                color: kwhite,
                              ),
                            )),
                          ),
                        ),
                      );
                    })),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: width,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(kdark),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ))),
                  onPressed: () {
                    _showAddDataDialog(context);
                  },
                  child: Text(
                    'Add Time and Subject',
                    style: TextStyle(color: kwhite, fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              
              child: StreamBuilder(
                stream: _firestore
                    .collection('schedule')
                    .doc(uid)
                    .collection(selectedDay)
                    .orderBy('starttime')
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
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Card(
                            color: kdark,
                            elevation: 1,
                            child: Container(
                              height: height * 0.09,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${data['starttime']} - ${data['endtime']}',
                                          style: TextStyle(
                                              color: kwhite, fontSize: 20)),
                                      Text(data['subject'],
                                          style: TextStyle(
                                              color: kwhite, fontSize: 20)),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _deleteDataFromFirestore(
                                              uid, document.id);
                                        },
                                      ),
                                    ]),
                              ),
                            )),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
