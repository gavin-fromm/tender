import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../back-end/authentification.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  static const creationSuccessful = SnackBar(
    content: Text('Password Updated! Redirecting.....'),
  );

  String? get _userEmail => Supabase.instance.client.auth.currentUser?.email;

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
        await Supabase.instance.client.auth
            .updateUser(UserAttributes(password: newPasswordController.text.trim()));
        // ignore: use_build_context_synchronously
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

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final RoundedLoadingButtonController updateInfoButton =
      RoundedLoadingButtonController();

  final incorrectPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Password',
      message: 'Password entered does not match current user',
      contentType: ContentType.failure,
    ),
    actions: const [SizedBox.shrink()],
  );

  final matchingPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Passwords do not match',
      message: 'Please confirm your new password',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(context),
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
        'Update Password',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: true,
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          SizedBox(height: 100),
          SizedBox(
              width: 200,
              height: 90,
              child: Icon(Icons.lock_clock, size: 70)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: oldPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.lock),
                labelText: 'Current Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.password_sharp),
                labelText: 'New Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: confirmNewPasswordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.password_sharp),
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
                if (oldPasswordController.text.isEmpty ||
                    newPasswordController.text.isEmpty ||
                    confirmNewPasswordController.text.isEmpty) {
                  updateInfoButton.error();
                  Timer(Duration(seconds: 1), () => updateInfoButton.reset());
                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(emptyInputMessage);
                  Timer(
                      Duration(seconds: 2),
                      () => ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner());
                } else if (newPasswordController.text !=
                    confirmNewPasswordController.text) {
                  updateInfoButton.error();
                  Timer(Duration(seconds: 2), () => updateInfoButton.reset());
                  ScaffoldMessenger.of(context)
                    ..hideCurrentMaterialBanner()
                    ..showMaterialBanner(matchingPasswordMessage);
                  Timer(
                      Duration(seconds: 2),
                      () => ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner());
                } else {
                  User? user = await signInWithEmailPassword(
                      _userEmail.toString(),
                      oldPasswordController.text.toString());
                  if (user != null) {
                    showAlertDialog(context);
                  } else {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 2), () => updateInfoButton.reset());
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
    );
  }
}
