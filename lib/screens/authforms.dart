import 'package:attendanceapp/screens/homeScreen.dart';
import 'package:attendanceapp/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendanceapp/screens/authscreens.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  bool isLogin = true;
  bool passwordVisible = false;

  void initState() {
    super.initState();
    passwordVisible = true;
  }

  startauthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        Fluttertoast.showToast(msg: "Login Succesfull");
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email, 'password': password});
        Fluttertoast.showToast(msg: "User Registered Successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                  child: Text(
                "Authenticate",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,

                ),
              )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        shadowColor: Colors.blue,
                        child: TextFormField(
                          style: TextStyle(color: kwhite, fontSize: 18),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please Enter a Valid Email Address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                          key: ValueKey('email'),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email_outlined),
                            suffixIconColor: kwhite,
                            filled: true,
                            fillColor: Colors.blue,
                            hintText: "Enter Your Email",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: kwhite, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: kwhite)),
                          ),
                        ),
                      ),
                      if (!isLogin)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10),
                            shadowColor: Colors.blue,
                            child: TextFormField(
                              style: TextStyle(color: kwhite, fontSize: 18),
                              onSaved: (value) {
                                _username = value!;
                              },
                              key: const ValueKey('username'),
                              decoration: InputDecoration(
                                suffixIconColor: kwhite,
                                suffixIcon: Icon(Icons.person),
                                filled: true,
                                fillColor: Colors.blue,
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                hintText: "Enter Your Username",
                                labelStyle: GoogleFonts.roboto(),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: kwhite, width: 2)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: kwhite)),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        shadowColor: Colors.blue,
                        child: TextFormField(
                          style: TextStyle(color: kwhite, fontSize: 18),
                          obscureText: passwordVisible,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Please Enter a Valid Password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                          key: ValueKey('password'),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                }),
                            filled: true,
                            fillColor: Colors.blue,
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                            hintText: "Enter Your Password",
                            labelStyle: GoogleFonts.roboto(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: kwhite, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: kwhite)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            startauthentication();
                          },
                          child: Text(
                            isLogin ? 'Login' : 'Sign-Up',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin
                                  ? 'Create an Account'
                                  : 'Already Have an Account-Log In',
                              style: TextStyle(color: kwhite, fontSize: 18),
                            )),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
