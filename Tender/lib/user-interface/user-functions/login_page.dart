import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/admin/admin_page.dart';
import 'package:food_for_thought/back-end/authentification.dart';
import 'package:food_for_thought/user-interface/user-functions/forgot_password_page.dart';
import 'package:food_for_thought/user-interface/user-functions/registration_page.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isHidden = true;
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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
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

  AppBar appBar() {
    return AppBar(
      toolbarHeight: 20,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.grey,
    );
  }

  Center body(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset('assets/logo/1.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
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
                obscureText: isHidden,
                decoration: InputDecoration(
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
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10, bottom: 0),
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

                          if (emailController.text.isEmpty) {
                            showSnackBar('Please enter an email!', true);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          } else if (passwordController.text.isEmpty) {
                            showSnackBar('Please enter a password!', true);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          } else {
                            User? user = await signInWithEmailPassword(
                                emailController.text.toString(),
                                passwordController.text.toString());

                            if (user != null) {
                              if (user.email == 'admin@admin.com') {
                                showSnackBar('Login successful!', false);
                                Timer(
                                  Duration(seconds: 1),
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AdminPage(),
                                    ),
                                  ),
                                );
                                return;
                              }

                              showSnackBar('Login successful!', false);
                              Timer(
                                  Duration(seconds: 1),
                                  () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomePage())));
                            } else if (!emailController.text.contains('@')) {
                              showSnackBar('Please enter a valid email!', true);
                            } else {
                              showSnackBar(
                                  'User not found. Please register first!',
                                  true);
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
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10, bottom: 0),
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
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegistrationPage()));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
