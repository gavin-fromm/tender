import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/user-interface/user-functions/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../back-end/authentification.dart';

//UI screen for updating user emails

class ChangeNamePage extends StatefulWidget {
  @override
  ChangeNamePageState createState() => ChangeNamePageState();
}

class ChangeNamePageState extends State<ChangeNamePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final RoundedLoadingButtonController updateInfoButton =
      RoundedLoadingButtonController();
  final _supabaseUser = Supabase.instance.client.auth.currentUser!;
  String get _userEmail => Supabase.instance.client.auth.currentUser?.email ?? '';

  static const creationSuccessful = SnackBar(
    content: Text('Name Updated! Redirecting.....'),
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
        await updateName(firstNameController.text.trim(),
            lastNameController.text.trim(), _supabaseUser.id);
        await signOut();
        // ignore: use_build_context_synchronously
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(creationSuccessful);
        }
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("You will be logged out after performing this action."),
      actions: [cancelButton, confirmButton],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final incorrectPasswordMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Password',
      message: 'password entered does not match current user',

      contentType: ContentType.failure,
      // to configure for material banner
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
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        backgroundColor: Color.fromARGB(255, 244, 4, 4),
        toolbarHeight: 40,
        centerTitle: true,
        title: Text(
          'Update Name',
          style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            SizedBox(
                width: 200,
                height: 90,
                child: Icon(
                  Icons.person,
                  size: 70,
                ) //to display the image
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: firstNameController,
                //Text Field for username/email
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                  labelText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: lastNameController,
                //Text Field for username/email
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                  labelText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                //Text Field for username/email
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    labelText: 'Confirm Password'),
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
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    updateInfoButton.error();
                    Timer(Duration(seconds: 1), () => updateInfoButton.reset());
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(emptyInputMessage);
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                  } else {
                    User? signedInUser = await signInWithEmailPassword(
                        _userEmail,
                        confirmPasswordController.text.toString());
                    if (signedInUser != null) {
                      showAlertDialog(context);
                    } else {
                      updateInfoButton.error();
                      Timer(
                          Duration(seconds: 2), () => updateInfoButton.reset());
                      // ignore: use_build_context_synchronously
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
