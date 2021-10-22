import 'package:flutter/material.dart';

class AppVersionControl extends StatelessWidget {
  // Parameters
  final String title;
  final String subtitle;
  final int appVersion;
  // Void CallBacks
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  AppVersionControl({
    required this.title,
    required this.subtitle,
    required this.appVersion,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      height: 63,
      child: Card(
        margin: const EdgeInsets.only(left: 0, right: 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: Colors.grey)),
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Decrement app version number
              SizedBox(
                width: 50,
                height: 30,
                child: TextButton(
                  child: Icon(Icons.remove),
                  onPressed: onDecrement,
                ),
              ),

              /// App Version number
              Text(appVersion.toString(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),

              /// Increment app version number
              SizedBox(
                width: 50,
                height: 30,
                child: TextButton(
                  child: Icon(Icons.add),
                  onPressed: onIncrement,
                ),
              ),
            ],
          ),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    ));
  }
}
