import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_for_thought/back-end/database.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:food_for_thought/user-interface/side-menu/help_page.dart';
import 'package:food_for_thought/user-interface/side-menu/pinned_recipes_page.dart';
import 'package:food_for_thought/user-interface/profile/profile_page.dart';
import 'package:food_for_thought/user-interface/side-menu/created_recipes_page.dart';
import 'package:food_for_thought/user-interface/side-menu/liked_recipes_page.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'about_us_page.dart';
import '../../back-end/authentification.dart';
import '../user-functions/login_page.dart';
import 'public_created_recipes_page.dart';

//class that defines the side bar menu of the applicaton -- Implemeted by : Gavin Fromm

class NavDrawer extends StatefulWidget {
  static const logOutMessage = SnackBar(
    content: Text('User Logged out'),
  );

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String uid = Supabase.instance.client.auth.currentUser!.id;
  bool loading = true;

  UserInformation? userInformation;

  Future<void> getUser() async {
    userInformation = await DatabaseService.getUser(uid);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget confirmButton = TextButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 244, 4, 4)),
      child: Text(
        "Logout",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
        signOut();
        ScaffoldMessenger.of(context).showSnackBar(NavDrawer.logOutMessage);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure you want to logout?"),
      actions: [cancelButton, confirmButton],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: sideMenu(context),
    );
  }

  ListView sideMenu(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(
          height: 110,
          child: DrawerHeader(
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 151, 151, 151)),
            child: loading
                ? Center(
                    child: SizedBox(
                      height: 30,
                      width: 70,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        strokeWidth: 2,
                        colors: [Color.fromARGB(255, 244, 4, 4)],
                      ),
                    ),
                  )
                : Row(
                    children: [
                      SizedBox(
                        width: 220,
                        height: 100,
                        child: RichText(
                          text: TextSpan(
                              text:
                                  '${userInformation?.firstName} ${userInformation?.lastName}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\n@${userInformation?.userName}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        icon: Icon(Icons.logout),
                        color: Colors.white,
                        iconSize: 35,
                      )
                    ],
                  ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.blue,
          ),
          title: Text('User Details'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ProfilePage()))
          },
        ),
        ListTile(
          leading: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          title: Text('Liked Recipes'),
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ViewSavedRecipesPage()))
          },
        ),
        ListTile(
          leading: Icon(
            Icons.push_pin,
            color: Colors.orange,
          ),
          title: Text('Pinned Recipes'),
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ViewPinnedRecipesPage()))
          },
        ),
        ListTile(
          leading: Icon(
            Icons.create,
            color: Colors.green,
          ),
          title: Text('Created Recipes'),
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => CreatedRecipesPage()))
          },
        ),
        ListTile(
          leading: Icon(
            Icons.verified,
            color: Colors.blue,
          ),
          title: Text('My Public Recipes'),
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PublicCreatedRecipesPage()))
          },
        ),
        ListTile(
          leading: Icon(
            Icons.help,
            color: Colors.blueGrey,
          ),
          title: Text('Help'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HelpPage()))
          },
        ),
        ListTile(
          leading: Icon(
            Icons.people,
            color: Colors.purple,
          ),
          title: Text('About Us'),
          onTap: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AboutUs()))
          },
        ),
        SizedBox(
          height: 120,
        ),
        // ListTile(
        //   leading: Icon(Icons.exit_to_app),
        //   title: Text('Logout'),
        //   onTap: () => {showAlertDialog(context)},
        // ),
      ],
    );
  }
}
