import 'package:dating_app_dashboard/widgets/my_circular_progress.dart';
import 'package:flutter/material.dart';

class Processing extends StatelessWidget {
  // Variables
  final String? text;

  const Processing({this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MyCircularProgress(),
          SizedBox(height: 10),
          Text(text ?? "Processing...", style: TextStyle(fontSize: 18)),
          SizedBox(height: 5),
          Text("Please wait!", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
