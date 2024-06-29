import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/back-end/authentification.dart';
import 'package:food_for_thought/user-interface/profile/change_email_page.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../user-functions/login_page.dart';
import 'change_name_page.dart';
import 'change_password_page.dart';
import 'change_username_page.dart';

//class to define how the profile information is presented to the user -- Implemented by : Gavin Fromm

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final emptyInputMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please input a password',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  final incorrectPassword = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Incorrect Password',
      message: 'The password is incorrect',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );

  final user = Supabase.instance.client.auth.currentUser!;
  String uid = Supabase.instance.client.auth.currentUser!.id;
  final userEmail = Supabase.instance.client.auth.currentUser?.email;
  String profilePicLink = " ";
  late String userId = uid.toString();
  UserInformation? userInformation;
  bool _isLoading = true;
  TextEditingController passwordFieldController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    userInformation = await DatabaseService.getUser(uid);
    setState(() {
      _isLoading = false;
    });
  }

  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );
  static const deletedMessage = SnackBar(
    content: Text('Account Deleted'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: _isLoading ? loadingIndicator() : body(context),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            ////
///////////////////////  PROFILE PHOTO  /////////////////////////
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 12),
                height: 120,
                width: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: Center(
                    child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 70,
                )),
              ),
            ),
///////////////////////  PROFILE PHOTO  /////////////////////////

            SizedBox(
              height: 10,
            ),
            ///////////////////////  DISPLAY NAME //////////////////////

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 244, 4, 4),
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 130,
                width: 300,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${userInformation?.firstName} ${userInformation?.lastName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Username: @${userInformation?.userName}',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Email: ${user.email!}',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 151, 151, 151),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 160,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ChangeEmailPage()));
                    },
                    child: Text(
                      'Change Email',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 151, 151, 151),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 160,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChangeUsernamePage()));
                    },
                    child: Text(
                      'Change Username',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 151, 151, 151),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 160,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ChangeNamePage()));
                    },
                    child: Text(
                      'Change Name',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 151, 151, 151),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 160,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChangePasswordPage()));
                    },
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 244, 4, 4),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 160,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Confirm"),
                        content: Text(
                            "Are you sure you want to delete your account? All data will be lost."),
                        actions: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 4, 4)),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return loading
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 220,
                                            ),
                                            Center(
                                              child: SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: LoadingIndicator(
                                                  indicatorType:
                                                      Indicator.ballRotateChase,
                                                  strokeWidth: 2,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 244, 4, 4)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'Loading Community Recipes...',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                    255,
                                                    244,
                                                    4,
                                                    4,
                                                  ),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      : AlertDialog(
                                          title: Text("Enter Password"),
                                          content: Text(
                                              "Please enter your password to confirm account deletion."),
                                          actions: [
                                            TextField(
                                              controller:
                                                  passwordFieldController,
                                              //Text Field for username/email
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                icon: Icon(Icons.lock),
                                                labelText: 'Password',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  244,
                                                                  4,
                                                                  4)),
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                TextButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  244,
                                                                  4,
                                                                  4)),
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    if (passwordFieldController
                                                        .value
                                                        .text
                                                        .isNotEmpty) {
                                                      User? signedInUser =
                                                          await signInWithEmailPassword(
                                                              userEmail
                                                                  .toString(),
                                                              passwordFieldController
                                                                  .value.text);
                                                      if (signedInUser != null) {
                                                        deleteUser(uid);
                                                        // ignore: use_build_context_synchronously
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    LoginPage()));
                                                        // ignore: use_build_context_synchronously
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                deletedMessage);
                                                      } else {
                                                        // ignore: use_build_context_synchronously
                                                        passwordFieldController
                                                            .clear();
                                                        // ignore: use_build_context_synchronously
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentMaterialBanner()
                                                          ..showMaterialBanner(
                                                              incorrectPassword);
                                                        Timer(
                                                            Duration(
                                                                seconds: 2),
                                                            () => ScaffoldMessenger
                                                                    .of(context)
                                                                .hideCurrentMaterialBanner());
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                        ..hideCurrentMaterialBanner()
                                                        ..showMaterialBanner(
                                                            emptyInputMessage);
                                                      Timer(
                                                          Duration(seconds: 2),
                                                          () => ScaffoldMessenger
                                                                  .of(context)
                                                              .hideCurrentMaterialBanner());
                                                    }
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center loadingIndicator() {
    return Center(
      child: SizedBox(
        height: 70,
        width: 70,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          strokeWidth: 2,
          colors: [Color.fromARGB(255, 244, 4, 4)],
        ),
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
        'User Information',
        style:
            TextStyle(color: Color.fromARGB(255, 247, 247, 247), fontSize: 20),
      ),
      automaticallyImplyLeading: true,
    );
  }
}
