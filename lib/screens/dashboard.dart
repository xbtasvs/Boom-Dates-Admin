import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/navigation_drawer.dart';
import 'package:dating_app_dashboard/widgets/processing.dart';
import 'package:dating_app_dashboard/widgets/users_pie_chart.dart';
import 'package:dating_app_dashboard/widgets/statistic_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Variables
  late Stream<DocumentSnapshot> _appInfo;
  Stream<QuerySnapshot>? _users;

  /// Get AppInfo Stream to update UI after changes
  void _getAppInfoUpdates() {
    _appInfo = AppModel().getAppInfoStream();
    // Listen updates
    _appInfo.listen((appEvent) {
      // Update AppInfo object
      AppModel().updateAppObject(appEvent.data()!);
    });
  }

  /// Get Users Stream to listen updates
  void _getUsersUpdates() {
    _users = AppModel().getUsers();
    // Listen updates
    _users!.listen((usersEvent) {
      // Update users
      AppModel().updateUsers(usersEvent.docs);
      //AppModel().creteFakeUsers(usersEvent.docs[0].data());r
    });
  }

  /// Count User Statistics
  int _countUsers(List<DocumentSnapshot> users, String userStatus) {
    // Variables
    String field = USER_STATUS;
    dynamic status = userStatus;
    // Check status
    if (userStatus == 'verified') {
      field = USER_IS_VERIFIED;
      status = true;
    }
    return users.where((user) => user.data()![field] == status).toList().length;
  }

  @override
  void initState() {
    super.initState();
    // Get updates
    _getUsersUpdates();
    _getAppInfoUpdates();
  }

  @override
  void dispose() {
    _appInfo.drain();
    _users?.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      drawer: NavigationDrawer(),
      backgroundColor: Colors.grey.withAlpha(70),
      body: StreamBuilder<QuerySnapshot>(
        stream: _users,
        builder: (context, snapshot) {
          // Check data
          if (!snapshot.hasData) {
            return Processing();
          } else {
            // Variables
            final List<DocumentSnapshot> users = snapshot.data!.docs;
            // G
            final int totalActiveUsers = _countUsers(users, 'active');
            final int totalVerifiedUsers = _countUsers(users, 'verified');
            final int totalFlaggedUsers = _countUsers(users, 'flagged');
            final int totalBlockedUsers = _countUsers(users, 'blocked');

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dashboard Header
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      color: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(Icons.score, size: 80, color: Colors.grey),
                          Text("Control Panel",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          Text("Watch your bussiness growing in real time!",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),

                  // Dashboard Statistics section 01
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Total Users
                        StatisticCard(
                          iconBgColor: Colors.green,
                          icon: Icons.person_add_outlined,
                          total: totalActiveUsers,
                          description: "Total Active Users",
                        ),

                        // Total Verified Users
                        StatisticCard(
                          iconBgColor: Colors.blue,
                          icon: Icons.check,
                          total: totalVerifiedUsers,
                          description: "Total Verified Users",
                        ),

                        // Total Flagged Users
                        StatisticCard(
                          iconBgColor: Colors.amber,
                          icon: Icons.flag_outlined,
                          total: totalFlaggedUsers,
                          description: "Total Flagged Users",
                        ),

                        // Total Blocked Users
                        StatisticCard(
                          iconBgColor: Colors.red,
                          icon: Icons.lock_outlined,
                          total: totalBlockedUsers,
                          description: "Total Blocked Users",
                        ),
                      ],
                    ),
                  ),

                  /// Show Pie Chart Statistic
                  UsersPieChart(
                    totalUsers: users.length,
                    totalActiveUsers: totalActiveUsers,
                    totalVerifiedUsers: totalVerifiedUsers,
                    totalFlaggedUsers: totalFlaggedUsers,
                    totalBlockedUsers: totalBlockedUsers,
                  ),
                ],
              ),
            );
          }
      }));
  }
}
