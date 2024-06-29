import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../back-end/authentification.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  ChangeEmailPageState createState() => ChangeEmailPageState();
}

class ChangeEmailPageState extends State<ChangeEmailPage> {
  TextEditingController oldEmailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final RoundedLoadingButtonController updateInfoButton =
      RoundedLoadingButtonController();

  static const creationSuccessful = SnackBar(
    content: Text('Email Updated! Redirecting.....'),
  );

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
        updateInfoButton.success();
        final supabase = Supabase.instance.client;
        await supabase.auth
            .updateUser(UserAttributes(email: newEmailController.text.trim()));
        updateUserEmail(newEmailController.text.trim(),
            supabase.auth.currentUser!.id);
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        signOut();
        ScaffoldMessenger.of(context).showSnackBar(creationSuccessful);
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

  final incorrectEmailMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Email',
      message: 'Email entered does not match current user',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );
  final incorrectPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Password',
      message: 'password entered does not match current user',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );
  final emptyInputMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please fill in all inputs',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );
  final emailFormatMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Email Format Incorrect',
      message: 'Please enter a valid email',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );

  @override
  Widget build(BuildContext context) {
    final currentEmail =
        Supabase.instance.client.auth.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 244, 4, 4),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'Update Email',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 100),
            SizedBox(
                width: 200,
                height: 90,
                child: Icon(Icons.person, size: 70)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: oldEmailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                    labelText: 'Old Email',
                    hintText: 'example@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: newEmailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                    labelText: 'New Email',
                    hintText: 'example@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock),
                    labelText: 'Confirm Password',
                    hintText: ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10, bottom: 0),
              child: RoundedLoadingButton(
                borderRadius: 8,
                width: 250,
                animateOnTap: false,
                resetDuration: Duration(seconds: 3),
                color: Color.fromARGB(255, 244, 4, 4),
                controller: updateInfoButton,
                onPressed: () async {
                  if (oldEmailController.text.isEmpty ||
                      newEmailController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 1), () => updateInfoButton.reset());
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(emptyInputMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  } else if (oldEmailController.text != currentEmail) {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 2), () => updateInfoButton.reset());
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(incorrectEmailMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  } else if (!newEmailController.text.contains('@')) {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 2), () => updateInfoButton.reset());
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(emailFormatMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  } else {
                    User? user = await signInWithEmailPassword(
                        oldEmailController.text.toString(),
                        confirmPasswordController.text.toString());
                    if (user != null) {
                      showAlertDialog(context);
                    } else {
                      updateInfoButton.error();
                      Timer(
                          Duration(seconds: 2), () => updateInfoButton.reset());
                      ScaffoldMessenger.of(context)
                        ..hideCurrentMaterialBanner()
                        ..showMaterialBanner(incorrectPasswordMessage);
                      Timer(
                          Duration(seconds: 2),
                          () => ScaffoldMessenger.of(context)
                              .hideCurrentMaterialBanner());
                    }
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
