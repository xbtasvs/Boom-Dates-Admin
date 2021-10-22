import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/datas/user.dart';
import 'package:dating_app_dashboard/dialogs/common_dialogs.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/show_scaffold_msg.dart';
import 'package:dating_app_dashboard/widgets/user_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatelessWidget {
  // Variables
  final User user;

  // Constructor
  ProfileScreen({required this.user});

  // Local variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Get user profile gallery
  List<String> get _getUserGallery {
    List<String> images = [];
    // loop user gallery
    if (user.userGallery != null) {
      user.userGallery!.forEach((key, imgUrl) {
        images.add(imgUrl);
      });
    }
    debugPrint('_getUserGallery() -> length: ${images.length}');
    return images;
  }

  // Copy text to Clipboard
  void _copyText(BuildContext context,
      {required String text, required String message}) {
    // Copy text
    Clipboard.setData(new ClipboardData(text: text));
    // Show success message
    showScaffoldMessage(
        context: context,
        scaffoldkey: _scaffoldKey,
        message: "$message Copied Successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("User profile"),
        elevation: 0,
        actions: <Widget>[
          /// Actions list
          PopupMenuButton<String>(
            initialValue: "",
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              /// Copy User ID
              PopupMenuItem(
                  value: "copy_user_id",
                  child: ListTile(
                    leading: Text("Copy User ID"),
                    trailing: Icon(Icons.copy_outlined),
                  )),

              /// Copy Phone Number
              PopupMenuItem(
                  value: "copy_phone_number",
                  child: ListTile(
                    leading: Text("Copy Phone Number"),
                    trailing: Icon(Icons.copy_outlined),
                  )),

              /// Update user status ex: Block/Active
              PopupMenuItem(
                  value: "update_user_status",
                  child: ListTile(
                    leading: Text(user.userStatus == 'active'
                        ? 'Block User'
                        : 'Activate User'),
                    trailing: Icon(user.userStatus == 'active'
                        ? Icons.lock_outline
                        : Icons.check_circle_outline_rounded),
                  )),
            ],
            onSelected: (val) {
              /// Control selected value
              switch (val) {
                case 'copy_user_id':
                  // Copy user ID
                  _copyText(context, text: user.userId, message: 'User ID');
                  break;

                case 'copy_phone_number':
                  // Copy user phone number
                  _copyText(context,
                      text: user.userPhoneNumber, message: 'User Phone Number');
                  break;

                case 'update_user_status':

                  // Update user status
                  // Show confirm dialog
                  String newStatus;
                  String message;
                  String positiveText;

                  // Check current user status
                  if (user.userStatus == 'active') {
                    newStatus = 'blocked';
                    positiveText = 'BLOCK';
                    message = 'User account will be Blocked!';
                  } else {
                    newStatus = 'active';
                    positiveText = 'ACTIVATE';
                    message = 'User account will be Activated!';
                  }

                  // Show dialog
                  confirmDialog(context,
                      message: message,
                      negativeText: 'CANCEL',
                      negativeAction: () => Navigator.of(context).pop(),
                      positiveText: positiveText,
                      positiveAction: () async {
                        // Update user status
                        await AppModel().updateUserData(
                            userId: user.userId,
                            data: {USER_STATUS: newStatus}).then((_) {
                          // Show success message
                          showScaffoldMessage(
                              context: context,
                              scaffoldkey: _scaffoldKey,
                              message: "Profile status updated successfully!");
                        }).catchError(() {
                          // Show error message
                          showScaffoldMessage(
                              context: context,
                              scaffoldkey: _scaffoldKey,
                              message:
                                  "Error while updating profile status.\nPlease try again later!");
                        });

                        // Close dialog
                        Navigator.of(context).pop();
                      });
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile Photo and statistics
          Container(
              padding: const EdgeInsets.only(top: 20),
              height: 445,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  // Profile photo
                  CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(user.userProfilePhoto)),
                  // Full name
                  SizedBox(height: 10),
                  Text(user.userFullname,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  // Profile location
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.location_on_outlined, color: Colors.white),
                    Text("${user.userCountry}, ${user.userLocality}",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ]),
                  SizedBox(height: 5),

                  /// Profile Statistics
                  Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              /// Show statistics
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // LIKES
                                    _showStatistic(
                                        icon: Icons.favorite_outline,
                                        title: 'LIKES',
                                        total: user.userTotalLikes),
                                    // VISITS
                                    _showStatistic(
                                        icon: Icons.remove_red_eye_outlined,
                                        title: 'VISITS',
                                        total: user.userTotalVisits),
                                    // DISLIKES
                                    _showStatistic(
                                        icon: Icons.cancel_outlined,
                                        title: 'DISLIKES',
                                        total: user.userTotalDisliked),
                                  ])
                            ]),
                          )))
                ],
              )),

          /// Profile Galery
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Profile Gallery",
                style: TextStyle(color: Colors.grey, fontSize: 18)),
          ),

          /// Show gallery
          _getUserGallery.isEmpty
              ? Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library_outlined,
                              color: Theme.of(context).primaryColor, size: 100),
                          SizedBox(height: 10),
                          Text("Gallery empty",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _getUserGallery.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey.withAlpha(70),
                      clipBehavior: Clip.antiAlias,
                      semanticContainer: true,
                      child: Image.network(_getUserGallery[index],
                          fit: BoxFit.fill),
                    );
                  }),
          Divider(thickness: 1),

          /// Profile Galery
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Profile information",
                style: TextStyle(color: Colors.grey, fontSize: 18)),
          ),
          Divider(thickness: 1),
          // User Bio
          ListTile(
              leading: Icon(Icons.info_outline,
                  color: Theme.of(context).primaryColor),
              title: Text('Bio'),
              trailing: Text(user.userBio)),

          Divider(thickness: 1),
          // User full name
          ListTile(
              leading: Icon(Icons.person_outline,
                  color: Theme.of(context).primaryColor),
              title: Text('Full name'),
              trailing: Text(user.userFullname)),
          Divider(thickness: 1),

          // User gender
          ListTile(
              leading: Icon(Icons.wc_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('Gender'),
              trailing: Text(user.userGender)),
          Divider(thickness: 1),

          // User Birthday
          ListTile(
            leading: Icon(Icons.calendar_today_outlined,
                color: Theme.of(context).primaryColor),
            title: Text('Birthday'),
            subtitle: Text('Current age: '
                '${AppModel().calculateUserAge(user.userBirthYear)}'),
            trailing: Text('${user.userBirthYear}/'
                '${user.userBirthMonth}/'
                '${user.userBirthDay}'), // Date Format: year/month/day
          ),
          Divider(thickness: 1),

          // User School
          ListTile(
            leading: Icon(Icons.school_outlined,
                color: Theme.of(context).primaryColor),
            title: Text('School'),
            trailing: Text(user.userSchool),
          ),
          Divider(thickness: 1),

          // User Job title
          ListTile(
            leading:
                Icon(Icons.work_outline, color: Theme.of(context).primaryColor),
            title: Text('Job title'),
            trailing: Text(user.userJobTitle),
          ),
          Divider(thickness: 1),

          // User location
          ListTile(
            leading: Icon(Icons.location_on_outlined,
                color: Theme.of(context).primaryColor),
            title: Text('Location'),
            trailing: Text("${user.userCountry}, ${user.userLocality}"),
          ),
          Divider(thickness: 1),

          // User Phone number
          ListTile(
              leading: Icon(Icons.call_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('Phone number'),
              trailing: Text(user.userPhoneNumber)),
          Divider(thickness: 1),

          // User Email
          ListTile(
              leading: Icon(Icons.email_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('Email'),
              trailing: Text(user.userEmail)),
          Divider(thickness: 1),

          // User Registration date
          ListTile(
            leading: Icon(Icons.create_outlined,
                color: Theme.of(context).primaryColor),
            title: Text('Registration date'),
            trailing: Text(AppModel()
                .formatDate(user.userRegDate)), // Date Format: year/month/day
          ),
          Divider(thickness: 1),

          // User Last active
          ListTile(
            leading: Icon(Icons.access_time_outlined,
                color: Theme.of(context).primaryColor),
            title: Text('Last active'),
            trailing: Text(timeago.format(user.userLastLogin)),
          ),
          Divider(thickness: 1),

          // User ID
          ListTile(
              leading: Icon(Icons.person_outline,
                  color: Theme.of(context).primaryColor),
              title: Text('User ID'),
              subtitle: Text(user.userId, style: TextStyle(fontSize: 17)),
              trailing: IconButton(
                icon: Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  // Copy user ID
                  _copyText(context, text: user.userId, message: 'User ID');
                },
              )),
          Divider(thickness: 1),

          // User Status
          ListTile(
              leading: Icon(Icons.info_outline,
                  color: Theme.of(context).primaryColor),
              title: Text('User Status'),
              trailing: UserStatus(status: user.userStatus)),
          Divider(thickness: 1),

          // User Verified
          ListTile(
            leading: Icon(Icons.verified_outlined,
                color: Theme.of(context).primaryColor),
            title: Text('User Verified'),
            subtitle: Text(
                'User is verified automatically when subscribe to VIP account'),
            trailing: UserStatus(
                status: user.userIsVerified ? 'verified' : 'Not verified'),
          ),
          Divider(thickness: 1),
          SizedBox(height: 30),
        ],
      )),
    );
  }

  // Show profile statistic - ex: TOTAL LIKES...
  Widget _showStatistic(
      {required IconData icon, required String title, required int total}) {
    return Row(
      children: [
        Icon(icon, size: 40, color: Colors.grey),
        SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text("$total", style: TextStyle(color: Colors.grey, fontSize: 18)),
          ],
        )
      ],
    );
  }
}
