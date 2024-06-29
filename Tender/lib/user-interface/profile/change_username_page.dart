import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import '../../back-end/authentification.dart';

class ChangeUsernamePage extends StatefulWidget {
  @override
  ChangeUsernamePageState createState() => ChangeUsernamePageState();
}

class ChangeUsernamePageState extends State<ChangeUsernamePage> {
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

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      style:
          TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 244, 4, 4)),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      style:
          TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 244, 4, 4)),
      child: Text(
        "Confirm change",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        final uid = Supabase.instance.client.auth.currentUser!.id;
        await updateUsername(newUsernameController.text.trim(), uid);
        await signOut();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
          showSnackBar('Username updated!', false);
        }
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("You will be logged out after performing this action."),
      actions: [cancelButton, confirmButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  TextEditingController newUsernameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(context),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          SizedBox(height: 150),
          SizedBox(
              width: 200,
              height: 90,
              child: Icon(Icons.person, size: 70)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newUsernameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alternate_email_rounded),
                labelText: 'New Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  labelText: 'Confirm Password'),
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

                        if (newUsernameController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          showSnackBar('Please fill in all inputs', true);
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          final userEmail =
                              Supabase.instance.client.auth.currentUser?.email;
                          User? user = await signInWithEmailPassword(
                              userEmail.toString(),
                              confirmPasswordController.text.toString());
                          if (user != null) {
                            showAlertDialog(context);
                          } else {
                            showSnackBar(
                                'Password entered does not match current user',
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
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
      backgroundColor: Color.fromARGB(255, 244, 4, 4),
      toolbarHeight: 40,
      centerTitle: true,
      title: Text(
        'Update Username',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: true,
    );
  }
}
