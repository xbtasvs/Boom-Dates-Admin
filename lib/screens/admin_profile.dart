import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/default_button.dart';
import 'package:dating_app_dashboard/widgets/default_card_border.dart';
import 'package:dating_app_dashboard/widgets/show_scaffold_msg.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  // Variables
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;

  @override
  void initState() {
    super.initState();
    // Initialize data
    _usernameController.text = AppModel().appInfo!.adminUsername;
    _passController.text = AppModel().appInfo!.adminPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Profile"),
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
                  Text("Admin Account",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Text("Profile information",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  SizedBox(height: 22),

                  /// Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        /// Username field
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              labelText: "Username",
                              hintText: "Enter your username",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefixIcon: Icon(Icons.person_outline)),
                          keyboardType: TextInputType.emailAddress,
                          validator: (username) {
                            // Basic validation
                            if (username?.isEmpty ?? true) {
                              return "Please enter your username";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        /// Password field
                        TextFormField(
                          controller: _passController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            labelText: "Password",
                            hintText: "Enter your password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  setState(() => _obscurePass = !_obscurePass);
                                }),
                          ),
                          obscureText: _obscurePass,
                          validator: (pass) {
                            if (pass?.isEmpty ?? true) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        /// Update button
                        SizedBox(
                          width: double.maxFinite,
                          child: DefaultButton(
                            child:
                                Text("Update", style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              /// Validate form
                              if (_formKey.currentState!.validate()) {
                                  // Update admin sign in info
                                  AppModel().updateAdminSignInInfo(
                                    adminUsername: _usernameController.text.trim(), 
                                    adminPassword: _passController.text.trim(), 
                                    onSuccess: () {
                                      // Show success message
                                      showScaffoldMessage(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          message: "Admin sign in info updated successfully!");
                                    }, 
                                    onError: () {
                                      // Show error message
                                      showScaffoldMessage(
                                          context: context,
                                          scaffoldkey: _scaffoldKey,
                                          message: "Error while updating Admin sign in info.\nPlease try again later!");
                                    }
                                );
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
