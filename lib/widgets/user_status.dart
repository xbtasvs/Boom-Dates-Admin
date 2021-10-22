import 'package:flutter/material.dart';

class UserStatus extends StatelessWidget {
  // Variable
  final String status;

  const UserStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    // Variables
    Color color = Theme.of(context).primaryColor;

    // Control user status
    switch (status) {
      case 'active':
        color = Colors.green;
        break;
      case 'verified':
        color = Colors.blue;
        break;
      case 'Not verified':
        color = Colors.black;
        break;
      case 'flagged':
        color = Colors.amber;
        break;
      case 'blocked':
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.only(top: 2, right: 6, left: 6, bottom: 4),
      child: Text(status,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
    );
  }
}
