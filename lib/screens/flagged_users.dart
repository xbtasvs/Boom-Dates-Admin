import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/my_circular_progress.dart';
import 'package:dating_app_dashboard/widgets/show_scaffold_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;

class FlaggedUsers extends StatelessWidget {
  // Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Copy User ID to Clipboard  
  void _copyUserId(BuildContext context, String text) {
      // Copy text
      Clipboard.setData(new ClipboardData(text: text));
      // Show success message
      showScaffoldMessage(
          context: context,
          scaffoldkey: _scaffoldKey,
          message: "User ID Copied Successfully!"); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Flagged Users Alert")
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: AppModel().getFlaggedUsersAlert(),
        builder: (context, snapshot) {
          // Check data
          if (!snapshot.hasData) return MyCircularProgress();
          return SingleChildScrollView(
           padding: const EdgeInsets.only(top: 15),
           scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text("Flagged User ID")
                ),
                DataColumn(
                  label: Text("Flag Reason")
                ),
                DataColumn(
                  label: Text("Time")
                ),
                DataColumn(
                  label: Text("Flagged By User ID")
                ),
                DataColumn(
                  label: Text("Remove"),
                  tooltip: 'Remove Flag Alert'
                ),
                
              ],
              rows: snapshot.data!.docs.map((flag) {
                return DataRow(
                  cells: [
                    DataCell(Row(
                      children: [
                        Text(flag[FLAGGED_USER_ID]),
                        SizedBox(width: 5),
                        Icon(Icons.copy_outlined, color: Colors.grey, size: 20)
                      ],
                    ), onTap: () {
                      // Copy Flagged User ID
                      _copyUserId(context, flag[FLAGGED_USER_ID]);
                    }),
                    DataCell(Text(flag[FLAG_REASON])),
                    DataCell(Text(timeago.format(flag[TIMESTAMP].toDate()))),
                    DataCell(Row(
                      children: [
                        Text(flag[FLAGGED_BY_USER_ID]),
                        SizedBox(width: 5),
                        Icon(Icons.copy_outlined, color: Colors.grey, size: 20)
                      ],
                    ), onTap: () {
                      // Copy User Author ID
                      _copyUserId(context, flag[FLAGGED_BY_USER_ID]);
                    }),
                    DataCell(Icon(Icons.delete_outlined, color: Colors.grey), 
                     onTap: () async {
                       // Delete flag report
                       await flag.reference.delete();
                       // Show success message
                       showScaffoldMessage(
                          context: context,
                          scaffoldkey: _scaffoldKey,
                          message: "Flag removed successfully!");
                       }),
                  ]
                );
              }).toList(),
            ),
          );
        }
      )
    );
  }
}