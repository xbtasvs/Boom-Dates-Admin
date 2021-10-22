import 'package:dating_app_dashboard/dialogs/progress_dialog.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/default_button.dart';
import 'package:dating_app_dashboard/widgets/default_card_border.dart';
import 'package:dating_app_dashboard/widgets/show_scaffold_msg.dart';
import 'package:flutter/material.dart';

class PushNotifications extends StatefulWidget {
  @override
  _PushNotificationsState createState() => _PushNotificationsState();
}

class _PushNotificationsState extends State<PushNotifications> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notifications"),
      ),
      key: _scaffoldKey,
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            elevation: 10.0,
            shape: defaultCardBorder(),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Push Notifications",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Text("Send push notifications to all users",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 22),

                  /// Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        /// message field
                        TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              labelText: "Text message",
                              hintText: "Write message",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefixIcon: Icon(Icons.mail_outline)),
                          keyboardType: TextInputType.emailAddress,
                          validator: (message) {
                            // Basic validation
                            if (message?.isEmpty ?? true) {
                              return "Please type message";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ///Send message button
                        SizedBox(
                          width: double.maxFinite,
                          child: DefaultButton(
                            child:
                                Text("Send message", style: TextStyle(fontSize: 18)),
                            onPressed: () async {
                              /// Validate form
                              if (_formKey.currentState!.validate()) {
                                  // instance
                                  final _pr = ProgressDialog(context); 
                                   // Show processing dialog
                                  _pr.show("Sending...");

                                 // Send push notifications to all users
                                 await AppModel().sendPushNotification(
                                   nBody: _messageController.text.trim(), 
                                   onSuccess: () {
                                      // Show success message
                                      showScaffoldMessage(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          message: "Push Notification Sent successfully!");
                                   }, 
                                   onError: () {
                                      // Show error message
                                      showScaffoldMessage(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          message: "Error while sending push notification!\nPlease try again later.");
                                   }
                                );
                                // close progress
                                _pr.hide();
                                // Clear text
                                _messageController.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
