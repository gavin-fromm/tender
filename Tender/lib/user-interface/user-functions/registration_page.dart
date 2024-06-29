import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../back-end/authentification.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool isLoading = false;

  void showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void toggleConfirmPasswordView() {
    setState(() {
      isHiddenConfirmPassword = !isHiddenConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: body(context),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/logo/2.png'),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
            child: TextField(
              controller: firstnameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
                labelText: 'First Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
            child: TextField(
              controller: lastnameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
                labelText: 'Last Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.mail),
                  labelText: 'Email',
                  hintText: 'example@gmail.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 15, bottom: 0),
            child: TextField(
              controller: passwordController,
              obscureText: isHiddenPassword,
              decoration: InputDecoration(
                focusColor: Colors.black,
                icon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText:
                    'Password must have at least 6 alphanumeric characters',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    togglePasswordView();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 15, bottom: 0),
            child: TextField(
              controller: confirmPasswordController,
              obscureText: isHiddenConfirmPassword,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
                hintText:
                    'Password must have at least 6 alphanumeric characters',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    toggleConfirmPasswordView();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 20, bottom: 30),
            child: SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 244, 4, 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            firstnameController.text.isEmpty ||
                            lastnameController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          showSnackBar('Please fill in all inputs', true);
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        } else if (passwordController.text.length <= 6) {
                          showSnackBar(
                              'Password must be at least 6 alphanumeric characters',
                              true);
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          showSnackBar('Passwords do not match', true);
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        } else {
                          User? user = await registerWithEmailPassword(
                              firstnameController.text.trim(),
                              lastnameController.text.trim(),
                              usernameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim());

                          if (user != null) {
                            showSnackBar(
                                'Account Created! Redirecting.....', false);
                            Timer(
                                Duration(seconds: 1),
                                () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginPage())));
                          } else if (!emailController.text.contains('@')) {
                            showSnackBar('Please enter a valid email', true);
                          } else {
                            showSnackBar(
                                'A user with this email already exists', true);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
              ),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.grey,
      centerTitle: true,
      title: Text(
        'Register',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}
