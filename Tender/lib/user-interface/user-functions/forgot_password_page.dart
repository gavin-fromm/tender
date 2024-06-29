import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  static String id = 'forgot-password';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> passwordReset() async {
    try {
      await Supabase.instance.client.auth
          .resetPasswordForEmail(_emailController.text.trim());
      return true;
    } on AuthException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: body(context),
    );
  }

  Form body(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.mail, color: Colors.grey),
                errorStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
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

                          if (_emailController.text.isEmpty) {
                            showSnackBar('Please enter an email!', true);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          if (await passwordReset()) {
                            showSnackBar('Password reset email sent!', false);
                            Timer(
                                Duration(seconds: 2),
                                () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginPage())));
                          } else {
                            showSnackBar(
                                'Email not found. Please register first!',
                                true);
                          }

                          setState(() {
                            isLoading = false;
                          });
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
                          'Send Email',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Reset Password',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      backgroundColor: Colors.grey,
      centerTitle: true,
    );
  }
}
