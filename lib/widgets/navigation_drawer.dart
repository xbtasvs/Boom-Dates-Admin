import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/screens/admin_profile.dart';
import 'package:dating_app_dashboard/screens/app_settings.dart';
import 'package:dating_app_dashboard/screens/dashboard.dart';
import 'package:dating_app_dashboard/screens/flagged_users.dart';
import 'package:dating_app_dashboard/screens/in_app_purchases.dart';
import 'package:dating_app_dashboard/screens/push_notifications.dart';
import 'package:dating_app_dashboard/screens/sign_in_screen.dart';
import 'package:dating_app_dashboard/screens/users_screen.dart';
import 'package:dating_app_dashboard/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  // Variables
  final _menuTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          /// DrawerHeader
          _drawerHeader(context),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.score),
            title: Text("Dashboard", style: _menuTextStyle),
            onTap: () {
              // Go to dashboard screen
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text("Users", style: _menuTextStyle),
            onTap: () {
              // Go to users screen
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => UsersScreen()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.flag_outlined),
            title: Text("Flagged Users", style: _menuTextStyle),
            onTap: () {
              // Go to flagged users screen
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => FlaggedUsers()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("App Settings", style: _menuTextStyle),
            onTap: () {
              // Go to app settings screen
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => AppSettings()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text("In-App Purchases", style: _menuTextStyle),
            onTap: () {
              // Go to In-App Purchases screen
              Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => InAppPurchases()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text("Push Notifications", style: _menuTextStyle),
            onTap: () {
              // Go to push notifications screen
              Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => PushNotifications()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Admin Profile", style: _menuTextStyle),
            onTap: () {
              // Go to admin account screen
              Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => AdminProfile()));
            },
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log out", style: _menuTextStyle),
            onTap: () {
              // Go to sign in screen
              Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => SignInScreen()));
            },
          ),
        ],
      ),
    );
  }
}

/// DrawerHeader
Widget _drawerHeader(BuildContext context) {
  return Container(
    color: Theme.of(context).primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// App logo
        AppLogo(),
        SizedBox(height: 10),
        Text(APP_NAME,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
